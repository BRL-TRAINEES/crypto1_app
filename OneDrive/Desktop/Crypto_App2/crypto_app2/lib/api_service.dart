import 'dart:convert';
import 'package:http/http.dart' as http;
import 'crypto_model.dart'; 

class ApiService {
  final String apiUrl = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd';

  Future<List<Crypto>> fetchCryptos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Crypto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cryptos');
    }
  }
}
