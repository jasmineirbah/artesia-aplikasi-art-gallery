import '../services/gemini_service.dart';

class ChatbotController {
  Future<String> getResponse(String message) async {
    final lower = message.toLowerCase();

    // 🔹 RULE-BASED (cepat & hemat)
    if (lower.contains("halo") || lower.contains("hi")) {
      return "Hello! Try searching 'Korean painting' or 'flower art'";
    }

    if (lower.contains("korea")) {
      return "You can explore Korean artworks 🇰🇷";
    }

    if (lower.contains("jepang")) {
      return "Try Japanese art 🎌";
    }

    if (lower.contains("bunga")) {
      return "Searching for flower-themed art 🌸";
    }

    // FALLBACK → GEMINI
    try {
      return await GeminiService.sendMessage(
        "Kamu adalah asisten aplikasi galeri seni bernama Artesia. Jawab singkat dan ramah.\nUser: $message",
      );
    } catch (e) {
      return "Maaf, lagi ada gangguan. Coba lagi ya 🙏";
    }
  }
}