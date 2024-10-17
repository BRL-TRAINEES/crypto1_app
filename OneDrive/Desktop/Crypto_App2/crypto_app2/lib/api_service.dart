import 'dart:convert';
import 'package:http/http.dart' as http;
import 'crypto_model.dart';

class ApiService {
  final String baseUrl = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd';


  Future<List<Crypto>> fetchCryptos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      print('Fetching from URL: $baseUrl');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Crypto.fromJson(json)).toList();
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to load cryptos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cryptocurrencies: $e');
      throw Exception('Error fetching cryptocurrencies: $e');
    }
  }

  
  Future<List<dynamic>> fetchChartData(String id) async {
    final url = 'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=7';

    try {
      final response = await http.get(Uri.parse(url));

      print('Fetching from URL: $url');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['prices']; 
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to load chart data for $id: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching chart data: $e');
      throw Exception('Error fetching chart data: $e');
    }
  }
}
