import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://192.168.56.1:8000'; // Ganti dengan base URL Anda
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static Future<List<dynamic>> getDataLansia() async {
    try {
      print('Fetching data from: $baseUrl/lansia');
      
      final response = await http.get(
        Uri.parse("$baseUrl/lansia"),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Network error: $e');
    }
  }
}