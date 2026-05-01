import '../services/currency_service.dart';

class CurrencyController {
  final CurrencyService _service = CurrencyService();

  Future<Map<String, double>> convert(double idr) async {
    final rates = await _service.getRates();

    return {
      "IDR": idr,
      "USD": idr * rates["USD"]!,
      "EUR": idr * rates["EUR"]!,
      "GBP": idr * rates["GBP"]!,
      "JPY": idr * rates["JPY"]!,
    };
  }
}