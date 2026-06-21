import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiLogin {
  // Ganti URL sesuai dengan host server Laravel kamu (misal jika lokal emulator: 10.0.2.2)
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  /// Fungsi untuk melakukan request login ke backend Laravel Sanctum
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Berhasil login (mengembalikan data yang berisi token, user, dan lokasi_user)
        return {
          'success': true,
          'message': responseData['message'] ?? 'Login berhasil',
          'token': responseData['token'],
          'user': responseData['user'],
        };
      } else {
        // Gagal login dari validasi backend (401 atau lainnya)
        return {
          'success': false,
          'message': responseData['message'] ?? 'Email atau password salah',
        };
      }
    } catch (e) {
      // Menangani kegagalan koneksi atau error sistem
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server. Periksa koneksi Anda.',
      };
    }
  }
}