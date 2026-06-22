import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model Data Rusunawa
class RusunawaModel {
  final String id;
  final String name;
  final String location;
  final String price;
  final int availableUnits;
  final List<String> facilities;
  String? imageUrl;

  RusunawaModel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.availableUnits,
    required this.facilities,
    this.imageUrl,
  });

  factory RusunawaModel.fromJson(Map<String, dynamic> json) {
    return RusunawaModel(
      id: json['id']?.toString() ?? '',
      name: json['nama_rusunawa'] ?? '',
      location: json['alamat'] ?? '',
      price: json['harga'] ?? '0',
      availableUnits: json['sisa_unit'] ?? 0,
      facilities: List<String>.from(json['fasilitas'] ?? []),
      imageUrl: json['image_url'],
    );
  }
}

class LogicRegister {
  static const String apiGambarUrl = "http://10.0.2.2:8000/api/gambar";
  static const String storageBaseUrl = "http://10.0.2.2:8000/storage/";

  /// Mengambil data 9 Rusunawa lengkap sesuai urutan ID database dan visual gambar
  static List<Map<String, dynamic>> getRawRusunawaData() {
    return [
      {
        'id': '1',
        'nama_rusunawa': 'Rusunawa Limusnunggal',
        'alamat': 'Kp. Limusnunggal RT.001/003 Desa Limusnunggal Kecamatan Cileungsi Kabupaten Bogor',
        'harga': '200rb',
        'sisa_unit': 80,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '2',
        'nama_rusunawa': 'Rusun Pekerja Dayeuh',
        'alamat': 'Kp. Rawa Jamun RT.004/004 Desa Dayeuh Kecamatan Cileungsi Kabupaten Bogor',
        'harga': '520rb',
        'sisa_unit': 8,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '4',
        'nama_rusunawa': 'Rusunawa Cingised',
        'alamat': 'Jalan Cingised, Kelurahan Cisaranten Kulon, Kecamatan Arcamanik, Kota Bandung, Jawa Barat',
        'harga': 'per bulan', // Di gambar tertulis "per bulan" tanpa nominal angka spesifik di atas teks kecil
        'sisa_unit': 483,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '5',
        'nama_rusunawa': 'Rumah Deret Tamansari',
        'alamat': 'Kawasan Rumah Deret Tamansari RW 11, Kelurahan Tamansari, Kecamatan Bandung Wetan, Kota Bandung, Jawa Barat',
        'harga': 'mulai dari per bulan',
        'sisa_unit': 0,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '7',
        'nama_rusunawa': 'Rusunawa Jatisari',
        'alamat': 'jatisari',
        'harga': '200rb',
        'sisa_unit': 108,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '8',
        'nama_rusunawa': 'Rusunawa Balegede',
        'alamat': 'Baleendah',
        'harga': '250rb',
        'sisa_unit': 38,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '9',
        'nama_rusunawa': 'Rusunawa Sadang Serang',
        'alamat': 'Kelurahan Sadang Serang, Kecamatan Coblong, Kota Bandung, Jawa Barat',
        'harga': 'mulai dari per bulan',
        'sisa_unit': 0,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '10',
        'nama_rusunawa': 'Rusunawa Rancacili',
        'alamat': 'Jl. Babakan Karet Rusunawa Rancacili, Kelurahan Derwati, Kecamtan Rancasari, Kota Bandung, Jawa Barat 40292',
        'harga': 'mulai dari per bulan',
        'sisa_unit': 326,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '12',
        'nama_rusunawa': 'Rusunawa Bekasi Jaya',
        'alamat': 'Jl. Baru Underpass RT. 009 RW.003 Kel. Bekasi Jaya Kec.Bekasi Timur Kota Bekasi',
        'harga': '255.000',
        'sisa_unit': 1,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
    ];
  }

  /// Memuat data gabungan antara properti dasar dan image endpoint dari API Laravel Gambar
  static Future<List<RusunawaModel>> fetchRusunawaWithImages() async {
    List<Map<String, dynamic>> rawData = getRawRusunawaData();
    List<RusunawaModel> rusunList = rawData.map((e) => RusunawaModel.fromJson(e)).toList();

    try {
      final response = await http.get(
        Uri.parse(apiGambarUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          List<dynamic> dataGambarJson = responseData['data'];

          for (var rusun in rusunList) {
            // Pencocokan fleksibel berdasarkan ID tabel gedung atau kecocokan substring nama gedung
            final match = dataGambarJson.firstWhere(
                  (g) => g['gedung_id'].toString() == rusun.id ||
                  rusun.name.toLowerCase().contains(g['gedung']['nama_gedung'].toString().toLowerCase()),
              orElse: () => null,
            );

            if (match != null) {
              String path = match['file_path'] ?? match['nama_gambar'] ?? '';
              rusun.imageUrl = path.startsWith('http') ? path : '$storageBaseUrl$path';
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Koneksi API Gambar bermasalah, menggunakan fallback default asset: $e");
    }

    return rusunList;
  }
}