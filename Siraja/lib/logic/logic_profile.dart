import 'dart:convert';
import 'package:http/http.dart' as http;

class LogicProfile {
  // Samakan baseUrl dengan host backend Laravel kamu
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  /// Fungsi untuk mengambil data profil user yang sedang login
  static Future<Map<String, dynamic>> getProfile(String token) async {
    final url = Uri.parse('$baseUrl/me');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Token dikirim via header Authorization
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal mengambil data profil.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server.',
      };
    }
  }
}