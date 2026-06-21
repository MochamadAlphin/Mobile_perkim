import 'package:http/http.dart' as http;

class ApiService {
  // Base URL mengarah ke emulator lokal laptop yang terhubung ke Laragon
  static const String baseUrl = "http://10.0.2.2:8000/api";

  // Client HTTP reusable
  final http.Client client = http.Client();

  // Helper untuk membuat request GET standar
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await client.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
  }
}