import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  Future<Map<String, double>> getRates() async {
    final res = await http.get(
      Uri.parse('https://api.frankfurter.app/latest?from=IDR'),
    );

    final data = jsonDecode(res.body);
    final rates = data['rates'];

    return {
      "IDR": 1,
      "USD": (rates['USD'] as num).toDouble(),
      "EUR": (rates['EUR'] as num).toDouble(),
      "GBP": (rates['GBP'] as num).toDouble(),
      "JPY": (rates['JPY'] as num).toDouble(),
    };
  }
}