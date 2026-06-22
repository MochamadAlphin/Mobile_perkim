import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardLogic {
  final String baseUrl = "http://10.0.2.2:8000/api";

  String? authToken;
  VoidCallback? onUpdate;

  DashboardLogic({this.authToken, this.onUpdate});

  // State operasional
  bool isLoading = false;
  String adminName = "Admin";
  int? userLokasiId; // Menyimpan ID Lokasi dari user yang sedang login

  // Statistik Properti & Penghuni
  int totalPenghuni = 0;
  int totalUnit = 0;
  int unitTerisi = 0;
  int unitKosong = 0;
  int kontrakAkanHabis = 0;

  // Demografi Umur
  int jmlBalita = 0;
  int jmlAnak = 0;
  int jmlRemaja = 0;
  int jmlDewasa = 0;
  int jmlLansia = 0;

  // Antrean Wawancara
  int belumDiwawancara = 0;
  int wawancaraHariIni = 0;
  int wawancaraBesok = 0;
  List<Map<String, dynamic>> daftarWawancara = [];

  Map<String, String> _getHeaders(String? explicitToken) {
    final tokenToUse = explicitToken ?? authToken;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (tokenToUse != null && tokenToUse.isNotEmpty) 'Authorization': 'Bearer $tokenToUse',
    };
  }

  /// Memuat data dashboard disaring dinamis berdasarkan akun user yang login
  Future<void> fetchDashboardData({String? updatedToken}) async {
    if (updatedToken != null) {
      authToken = updatedToken;
    }

    isLoading = true;
    _notify();
    _resetStatistics();

    final Map<String, String> headers = _getHeaders(updatedToken);

    try {
      debugPrint("--- REFRESH DATA DASHBOARD SIRAJA (TAHUN 2026) ---");

      // 1. Dapatkan Profil User yang sedang Login untuk mengambil nama & lokasi_id
      try {
        final resProfile = await http.get(Uri.parse('$baseUrl/me'), headers: headers);
        if (resProfile.statusCode == 200) {
          final dynamic profileBody = json.decode(resProfile.body);
          Map<String, dynamic>? userData = profileBody['data'] ?? profileBody;

          if (userData != null) {
            adminName = (userData['name'] ?? "Admin").toString();

            // Mengambil lokasi_id dari root data atau nested objek lokasi_user
            if (userData['lokasi_id'] != null && userData['lokasi_id'].toString() != 'null') {
              userLokasiId = int.tryParse(userData['lokasi_id'].toString());
            } else if (userData['lokasi_user'] != null && userData['lokasi_user'] is List && userData['lokasi_user'].isNotEmpty) {
              var firstLoc = userData['lokasi_user'][0];
              userLokasiId = int.tryParse((firstLoc['lokasi_id'] ?? '').toString());
            } else if (userData['lokasi'] != null && userData['lokasi']['id'] != null) {
              userLokasiId = int.tryParse(userData['lokasi']['id'].toString());
            } else {
              userLokasiId = null; // Super Admin / Akses Global
            }
            debugPrint("🔒 Login sebagai: $adminName | Terfilter Lokasi ID: $userLokasiId");
          }
        }
      } catch (e) {
        debugPrint("Gagal mengambil data session profil: $e");
      }

      // 2. Ambil Data Hirarki Lokasi & Pendaftar secara Paralel
      final responses = await Future.wait([
        http.get(Uri.parse('$baseUrl/lokasi-hirarki'), headers: headers),
        http.get(Uri.parse('$baseUrl/pendaftar'), headers: headers),
      ]);

      // 3. Parsing Data Hirarki Lokasi
      if (responses[0].statusCode == 200) {
        final Map<String, dynamic> body = json.decode(responses[0].body);
        _processLokasiHirarki(body['data'] ?? body);
      } else {
        debugPrint("Gagal memuat lokasi-hirarki [${responses[0].statusCode}]: ${responses[0].body}");
      }

      // 4. Parsing Data Antrean Wawancara
      if (responses[1].statusCode == 200) {
        final dynamic body = json.decode(responses[1].body);
        _processPendaftarWawancara(body['data'] ?? body);
      }

    } catch (e) {
      debugPrint("Fatal Exception Dashboard Logic: $e");
    } finally {
      isLoading = false;
      _notify();
    }
  }

  void _resetStatistics() {
    totalPenghuni = 0;
    totalUnit = 0;
    unitTerisi = 0;
    unitKosong = 0;
    kontrakAkanHabis = 0;
    jmlBalita = 0;
    jmlAnak = 0;
    jmlRemaja = 0;
    jmlDewasa = 0;
    jmlLansia = 0;
    belumDiwawancara = 0;
    wawancaraHariIni = 0;
    wawancaraBesok = 0;
    daftarWawancara = [];
  }

  void _processLokasiHirarki(dynamic lokasiUserList) {
    if (lokasiUserList == null || lokasiUserList is! List) return;

    final DateTime todayZeroHour = DateTime(2026, DateTime.now().month, DateTime.now().day);

    for (var lokasiUser in lokasiUserList) {
      if (lokasiUser == null) continue;

      var lokasi = lokasiUser['lokasi'] ?? lokasiUser;
      if (lokasi == null || lokasi is! Map) continue;

      // FILTER LOKASI
      if (userLokasiId != null) {
        var currentLokasiId = lokasi['id'] ?? lokasiUser['lokasi_id'];
        if (currentLokasiId != null && int.tryParse(currentLokasiId.toString()) != userLokasiId) {
          continue;
        }
      }

      var gedungList = lokasi['gedung'] ?? lokasi['gedungs'];
      if (gedungList == null || gedungList is! List) continue;

      for (var gedung in gedungList) {
        if (gedung == null) continue;

        var unitList = gedung['unit'] ?? gedung['units'];
        if (unitList == null || unitList is! List) continue;

        for (var unit in unitList) {
          if (unit == null) continue;
          totalUnit++;

          // Ambil daftar kontrak aktif untuk unit ini
          var kontraks = unit['kontrak'] ?? unit['kontraks'];
          List<dynamic> activeContracts = [];

          if (kontraks != null && kontraks is List) {
            for (var k in kontraks) {
              if (k == null) continue;
              String statusKontrak = (k['status_kontrak'] ?? '').toString().trim();
              if (statusKontrak == '1' || statusKontrak == 'true' || statusKontrak == '') {
                activeContracts.add(k);
              }
            }
          }

          // VALIDASI STATUS JUAL
          String statusJual = (unit['status_jual'] ?? '').toString().trim();
          if (statusJual == '1' || statusJual.toLowerCase() == 'terisi' || activeContracts.isNotEmpty) {
            unitTerisi++;
          } else {
            unitKosong++;
          }

          // Proses data kontrak & pengecekan penghuni secara menyeluruh
          for (var kontrak in activeContracts) {
            if (kontrak['tgl_akhir'] != null) {
              try {
                DateTime tglAkhir = DateTime.parse(kontrak['tgl_akhir'].toString().split(' ')[0]);
                int sisaHari = tglAkhir.difference(todayZeroHour).inDays;
                if (sisaHari >= 0 && sisaHari <= 7) {
                  kontrakAkanHabis++;
                }
              } catch (_) {}
            }

            // STRATEGI 1: Periksa relasi array kolektif 'penghunis' atau 'penghuni' (Sering digunakan di Laravel)
            var listPenghuni = kontrak['penghunis'] ?? kontrak['penghuni'];
            if (listPenghuni != null && listPenghuni is List) {
              for (var p in listPenghuni) {
                _checkAndParsePenghuni(p);
              }
            }

            // STRATEGI 2: Tetap periksa kolom pecahan individual (penghuni_satu, dst.) untuk cadangan
            _checkAndParsePenghuni(kontrak['penghuni_satu'] ?? kontrak['penghuniSatu']);
            _checkAndParsePenghuni(kontrak['penghuni_dua'] ?? kontrak['penghuniDua']);
            _checkAndParsePenghuni(kontrak['penghuni_tiga'] ?? kontrak['penghuniTiga']);
            _checkAndParsePenghuni(kontrak['penghuni_empat'] ?? kontrak['penghuniEmpat']);
          }
        }
      }
    }
  }

  void _checkAndParsePenghuni(dynamic pData) {
    if (pData == null) return;

    if (pData is List && pData.isNotEmpty) {
      for (var item in pData) {
        _parsePenghuniUmur(item);
      }
    } else if (pData is Map) {
      _parsePenghuniUmur(pData);
    }
  }

  void _parsePenghuniUmur(dynamic p) {
    // Pastikan ini adalah objek Map data diri penghuni dan memiliki field tgl_lahir
    if (p == null || p is! Map || p['tgl_lahir'] == null) return;

    // Antisipasi duplikasi perhitungan jika data yang sama terpanggil dari dua strategi di atas
    totalPenghuni++;
    try {
      String tglLahirRaw = p['tgl_lahir'].toString().split(' ')[0]; // Ambil YYYY-MM-DD
      DateTime tglLahir = DateTime.parse(tglLahirRaw);

      // SINKRONISASI TAHUN REAL-TIME DASHBOARD (2026)
      int tahunSekarang = 2026;
      int umur = tahunSekarang - tglLahir.year;

      DateTime now2026 = DateTime(2026, DateTime.now().month, DateTime.now().day);
      if (now2026.month < tglLahir.month || (now2026.month == tglLahir.month && now2026.day < tglLahir.day)) {
        umur--;
      }

      // Klasifikasi kategori demografi umur ke variabel state
      if (umur <= 5) {
        jmlBalita++;
      } else if (umur <= 11) {
        jmlAnak++;
      } else if (umur <= 25) {
        jmlRemaja++;
      } else if (umur <= 45) {
        jmlDewasa++;
      } else {
        jmlLansia++;
      }
    } catch (e) {
      debugPrint("Gagal memproses kalkulasi umur: $e");
    }
  }

  void _processPendaftarWawancara(dynamic pendaftarList) {
    if (pendaftarList == null || pendaftarList is! List) return;

    String tglHariIni = "2026-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
    String tglBesok = "2026-${DateTime.now().month.toString().padLeft(2, '0')}-${(DateTime.now().day + 1).toString().padLeft(2, '0')}";

    for (var p in pendaftarList) {
      if (p == null) continue;

      if (userLokasiId != null) {
        var pendaftarLokasiId = p['lokasi_id'] ?? (p['lokasi'] != null ? p['lokasi']['id'] : null);
        if (pendaftarLokasiId != null && int.tryParse(pendaftarLokasiId.toString()) != userLokasiId) {
          continue;
        }
      }

      String statusFormulir = (p['status_formulir'] ?? '').toString().toLowerCase().trim();
      if (statusFormulir == 'masuk') belumDiwawancara++;

      String? tglWawancaraApi = p['tgl_wawancara'] != null ? p['tgl_wawancara'].toString().split(' ')[0] : null;
      if (tglWawancaraApi == tglHariIni) wawancaraHariIni++;
      if (tglWawancaraApi == tglBesok) wawancaraBesok++;

      if (daftarWawancara.length < 3) {
        daftarWawancara.add({
          "nama": p['nama'] ?? "Tanpa Nama",
          "tgl_wawancara": tglWawancaraApi == tglHariIni ? "Hari ini" : (tglWawancaraApi == tglBesok ? "Besok" : tglWawancaraApi ?? "Belum Terjadwal"),
          "jam": p['jam_wawancara'] ?? p['jam'] ?? "--:-- WIB",
          "lokasi_tujuan": p['lokasi']?['nama_lokasi'] ?? "Rusun Perkim",
        });
      }
    }
  }

  void _notify() => onUpdate?.call();
}