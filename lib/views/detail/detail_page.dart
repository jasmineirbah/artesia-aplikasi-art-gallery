import 'dart:convert';
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
  double convertedPrice = 0;
  String jakartaTime = "--:--";
  final SensorController sensorController = SensorController();

  @override
  void initState() {
    super.initState();

    convertCurrency();
    getTime();

    sensorController.start(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    sensorController.dispose();
    super.dispose();
  }

  /// 💱 CURRENCY API
  Future<void> convertCurrency() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'),
      );

      final data = jsonDecode(res.body);

      final usd = 100;

      final rate = (data['rates']['IDR'] as num).toDouble();

      setState(() {
        convertedPrice = usd * rate;
      });
    } catch (e) {
      convertedPrice = 0;
    }
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Exhibition Location",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// LOCATION
              Text(
                widget.art['location'],
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Address not available",
                style: GoogleFonts.inter(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// TIME
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
                      style: GoogleFonts.inter(fontSize: 16),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// MAP BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {},
                  child: const Text("Open in Maps"),
                ),
              ),
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔙 BACK
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

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

              Text(
                art['title'],
                style: GoogleFonts.inter(fontSize: 14),
              ),

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
                    )
                  ],
                ),
                child: ClipRect(
                  child: Transform.translate(
                    offset: Offset(
                      sensorController.offsetX,
                      sensorController.offsetY,
                    ),
                    child: Image.network(
                      art['image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 📄 INFO
              Text(
                art['medium'],
                style: GoogleFonts.inter(fontSize: 13),
              ),

              const SizedBox(height: 6),

              Text(
                art['dimensions'],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              /// 💰 PRICE ORIGINAL
              Text(
                art['price'],
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              /// 💱 CONVERTED
              Text(
                "≈ Rp ${convertedPrice.toStringAsFixed(0)}",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              /// 📍 BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: showLocationPopup,
                    child: const Text("Show The Location"),
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