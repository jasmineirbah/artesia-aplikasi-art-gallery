import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/chatbot_controller.dart';
import '../../widgets/app_logo.dart';
import 'package:artesia_aplikasi_art_gallery/controllers/search_controller.dart' as search;
import '../../services/api_service.dart';
import '../../widgets/art_card.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ChatbotController chatbot = ChatbotController();

  //List<Map<String, String>> messages = [];

  final search.SearchController searchController = search.SearchController();
  final ApiService apiService = ApiService();

  List<Map<String, dynamic>> artworks = [];
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    loadArtworks();

    messages.add({
      "role": "bot",
      "text": "Hi! Try 'Korean painting' or 'flower art'"
    });
  }

  Future<void> loadArtworks() async {
    final data = await apiService.fetchArtworks();
    setState(() {
      artworks = data;
    });
  }

 void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final response = await chatbot.getResponse(text);

    // PREFIX
    final results = searchController.search(text, artworks);

    setState(() {
      messages.add({"role": "user", "text": text});
      messages.add({"role": "bot", "text": response});

      if (results.isNotEmpty) {
        messages.add({
          "role": "artwork",
          "data": results.take(3).toList(),
        });
      }
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(showBackButton: false),
            const SizedBox(height: 6),
            Text(
              'Chatbot',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // BODY
      body: Column(
        children: [
          /// 💬 CHAT AREA
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                /// 🔹 TEXT MESSAGE (USER / BOT)
                if (msg["role"] == "user" || msg["role"] == "bot") {
                  final isUser = msg["role"] == "user";

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg["text"] ?? "",
                        style: GoogleFonts.inter(
                          color: isUser ? Colors.white : Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }

                // ARTWORK MESSAGE
                if (msg["role"] == "artwork") {
                  final List arts = msg["data"] as List;

                  return SizedBox(
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: arts.length,
                      itemBuilder: (context, i) {
                        final art = arts[i];

                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 180,
                            child: ArtCard(
                              art: art,
                              artist: art['artist'],
                              title: art['title'],
                              price: art['price'],
                              image: art['image'],
                              medium: art['medium'],
                              isFavorite: false,
                              isSmall: true,
                              onFavoriteToggle: () {},
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),

          // INPUT AREA
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}