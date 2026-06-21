import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:siraja/screens/splash_screen.dart';
import 'package:siraja/screens/login_screen.dart';
import 'package:siraja/widgets/bottom_nav.dart'; // <--- Sesuaikan path file MainNavigationScreen kamu

void main() {
  runApp(const MyApp());
}

// Mengubah MyApp menjadi StatefulWidget agar bisa menjalankan fungsi cek koneksi saat aplikasi pertama kali dimuat
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi cek koneksi ke Laravel secara otomatis saat aplikasi dijalankan
    cekKoneksiKeLaravel();
  }

  // FUNGSI CEK KONEKSI KE BACKEND LARAVEL
  Future<void> cekKoneksiKeLaravel() async {
    // Sesuaikan endpoint ini dengan route yang ada di routes/api.php Laravel kamu (misal: lokasi_user atau endpoint test lainnya)
    // Menggunakan 10.0.2.2 karena berjalan di 1 laptop menggunakan Emulator Android Studio
    final String urlTest = "http://10.0.2.2:8000/api/lokasi_user";

    try {
      print("==================================================");
      print("🚀 [SIRAJA] Memulai Tes Koneksi ke Backend Laravel...");
      print("==================================================");

      final response = await http.get(Uri.parse(urlTest));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("✅ [SIRAJA] KONEKSI BERHASIL (Status 200)!");
        print("📦 Data dari Database Laragon: $data");
      } else {
        print("⚠️ [SIRAJA] NYAMBUNG TAPI SERVER ERROR: Status ${response.statusCode}");
        print("📄 Respon Laravel: ${response.body}");
      }
    } catch (e) {
      print("❌ [SIRAJA] KONEKSI GAGAL TOTAL!");
      print("🚨 Masalah: $e");
      print("💡 Tips: Pastikan 'php artisan serve' di terminal proyek Laravel kamu sudah menyala.");
    }
    print("==================================================");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIRAJA',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF102E5A), // Warna primary SIRAJA
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Background abu terang
        fontFamily: 'Roboto',
      ),

      // Menjadikan SplashScreen sebagai halaman pertama saat aplikasi dibuka
      home: const SplashScreen(),

      // Mendaftarkan rute navigasi global
      routes: {
        '/main': (context) => const MainNavigationScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}