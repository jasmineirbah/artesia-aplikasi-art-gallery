import 'dart:convert';
import 'package:artesia_aplikasi_art_gallery/controllers/currency_controller.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/app_logo.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../controllers/sensor_controller.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> art;

  const DetailPage({super.key, required this.art});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final CurrencyController currencyController = CurrencyController();
  Map<String, double> currencies = {};

  double convertedPrice = 0;
  String jakartaTime = "--:--";
  final SensorController sensorController = SensorController();

  double parsePrice(String price) {
    final cleaned = price
        .replaceAll('Rp', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(cleaned) ?? 0;
  }

  @override
  void initState() {
    super.initState();

    loadCurrency();

    sensorController.start(() {
      setState(() {}); // 🔥 WAJIB
    });
  }

  Widget _buildPriceRow(String country, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            country,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color.fromARGB(255, 110, 110, 110),
            ),
          ),
          Text(
            price,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 1,
    );
  }

  
  void loadCurrency() async {
    final rawPrice = parsePrice(widget.art['price']);

    final result = await currencyController.convert(rawPrice);

    setState(() {
      currencies = result;
    });
  }

  @override
  void dispose() {
    sensorController.dispose();
    super.dispose();
  }

  /// 🌍 TIME API
  Future<void> getTime() async {
    try {
      final res = await http.get(
        Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Jakarta'),
      );

      final data = jsonDecode(res.body);

      final datetime = data['datetime'];
      final time = datetime.substring(11, 16);

      setState(() {
        jakartaTime = time;
      });
    } catch (e) {
      jakartaTime = "--:--";
    }
  }

  /// 📍 POPUP LOCATION
  void showLocationPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFBF9F4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// HANDLE
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// 🔥 TITLE (CENTER)
              Text(
                "Exhibition Location",
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              /// 📍 LOCATION CENTER
              Text(
                widget.art['location'],
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              /// 🕒 TIME CARD
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Local Time\n$jakartaTime WIB",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 PRIMARY BUTTON
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: "Open in Maps",
                  onPressed: () {},
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final art = widget.art;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: const AppLogo(),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    /// 🎨 TITLE
                    Text(
                      art['artist'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(art['title'], style: GoogleFonts.inter(fontSize: 14)),

                    const SizedBox(height: 20),

                    /// 🖼 IMAGE
                    Container(
                      height: 320,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRect(
                        child: Transform.translate(
                          offset: Offset(
                            sensorController.offsetX,
                            sensorController.offsetY,
                          ),
                          child: (art['image']?.toString() ?? '').isEmpty
                              ? Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey[400],
                                  size: 54,
                                )
                              : Image.network(
                                  art['image'],
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey[400],
                                      size: 54,
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 📄 INFO
                    Text(art['medium'], style: GoogleFonts.inter(fontSize: 13)),

                    const SizedBox(height: 6),

                    Text(
                      art['dimensions'],
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// 💰 PRICE ORIGINAL
                    Text(
                      art['price'],
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// 💱 CONVERTED
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "PRICING DETAILS",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          _divider(),

                          const SizedBox(height: 16),

                          _buildPriceRow("INDONESIA", "Rp ${currencies['IDR']?.toStringAsFixed(0) ?? '-'}"),
                          _divider(),

                          _buildPriceRow("UNITED STATES", "\$${currencies['USD']?.toStringAsFixed(2) ?? '-'}"),
                          _divider(),

                          _buildPriceRow("EUROPE", "€${currencies['EUR']?.toStringAsFixed(2) ?? '-'}"),
                          _divider(),

                          _buildPriceRow("UNITED KINGDOM", "£${currencies['GBP']?.toStringAsFixed(2) ?? '-'}"),
                          _divider(),

                          _buildPriceRow("JAPAN", "¥${currencies['JPY']?.toStringAsFixed(0) ?? '-'}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              /// 📍 BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: "SHOW LOCATION",
                      onPressed: showLocationPopup,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
