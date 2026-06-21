import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // =========================================================================
  // TEMPAT ASSIGN DATA DARI API NANTI (KOSONG / MOCK DATA OPERASIONAL)
  // =========================================================================
  bool _isLoading = false;

  // Global Brand Color Palette (Dipakai di seluruh State widget)
  final Color _activeColor = const Color(0xFF102E5A);
  final Color _inactiveColor = const Color(0xFF9E9E9E);

  // Master Data Statistik Utama
  int totalPenghuni = 142;       // Berdasarkan baris tabel perkim_penghuni
  int totalUnit = 100;           // Total seluruh baris perkim_unit
  int unitTerisi = 85;           // perkim_unit WHERE status_jual = 'Terisi'
  int unitKosong = 15;           // perkim_unit WHERE status_jual = 'Kosong'

  // Perubahan Aturan Kontrak Kritis (1 Minggu Sebelum Habis / H-7 tgl_akhir)
  int kontrakAkanHabis = 3;

  // Data Demografi Kelompok Umur (Kalkulasi Berdasarkan perkim_penghuni -> tgl_lahir)
  // Klasifikasi menggunakan Standar Resmi Ditjen Kesmas / Kemenkes RI
  int jmlBalita = 12;            // Umur 0 - 5 Tahun
  int jmlAnak = 18;              // Umur 6 - 11 Tahun
  int jmlRemaja = 35;            // Umur 12 - 25 Tahun
  int jmlDewasa = 55;            // Umur 26 - 45 Tahun
  int jmlLansia = 22;            // Umur > 45 Tahun

  // Data Perhatian Sistem: Pendaftar Wawancara Baru
  int belumDiwawancara = 8;      // Total pendaftar dengan status_formulir masuk
  int wawancaraHariIni = 2;      // Jadwal wawancara tanggal hari ini
  int wawancaraBesok = 3;        // Jadwal wawancara tanggal besok

  // List Kosong Mock-up untuk API Daftar Pendaftar Wawancara
  List<Map<String, dynamic>> daftarWawancara = [
    {
      "nama": "Andi Wijaya",
      "tgl_wawancara": "Hari ini, 21 Juni 2026",
      "jam": "09:00 WIB",
      "lokasi_tujuan": "Blok A - Rumah Susun Perkim"
    },
    {
      "nama": "Siti Rahma",
      "tgl_wawancara": "Hari ini, 21 Juni 2026",
      "jam": "13:30 WIB",
      "lokasi_tujuan": "Blok B - Rusunawa"
    },
    {
      "nama": "Budi Santoso",
      "tgl_wawancara": "Besok, 22 Juni 2026",
      "jam": "10:00 WIB",
      "lokasi_tujuan": "Blok A - Rumah Susun Perkim"
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Menghitung persentase rasio keterisian unit secara dinamis
    double rasioOkupansiAngka = totalUnit > 0 ? (unitTerisi / totalUnit) : 0.0;
    String rasioOkupansiTeks = "${(rasioOkupansiAngka * 100).toStringAsFixed(0)}%";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16.0,
        title: Text(
          'Perkim Dashboard',
          style: TextStyle(color: _activeColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: _activeColor),
            onPressed: () {
              // Trigger refresh data API di sini nanti
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Ucapan
            Text(
              'Halo, Admin 👋',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _activeColor),
            ),
            const SizedBox(height: 2),
            const Text(
              'Sistem Manajemen Hunian Terintegrasi Perkim.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // 2. CARD REMINDER / PERHATIAN SISTEM (INTEGRASI LOGIN & WAWANCARA)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.shade200, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gpp_maybe_rounded, color: Colors.red.shade800, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Perhatian Sistem Utama',
                        style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 0.5, color: Colors.redAccent),

                  // Notifikasi Jadwal Wawancara Masuk
                  Text(
                    '• Terdapat $belumDiwawancara calon penghuni baru yang belum diwawancara.\n'
                        '• Jadwal Wawancara HARI INI: $wawancaraHariIni orang terdata.\n'
                        '• Jadwal Wawancara BESOK: $wawancaraBesok orang terdata.',
                    style: TextStyle(color: Colors.red.shade900, fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),

                  // Notifikasi Kontrak Jatuh Tempo (Aturan Baru H-7)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.alarm, color: Colors.red.shade700, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kritis H-7: Ada $kontrakAkanHabis kontrak akomodasi yang habis dalam waktu kurang dari 1 minggu.',
                            style: TextStyle(color: Colors.red.shade900, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Card Rasio Okupansi Properti
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _activeColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rasio Keterisian Unit Properti (Okupansi)',
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rasioOkupansiTeks,
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$unitTerisi Terisi / $totalUnit Unit',
                        style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: rasioOkupansiAngka,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Grid Ringkasan Atribut Data Kamar & Jiwa
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                _buildSummaryCard(
                  icon: Icons.people_alt_outlined,
                  title: 'Total Penghuni',
                  value: '$totalPenghuni Jiwa',
                  iconColor: Colors.blue,
                ),
                _buildSummaryCard(
                  icon: Icons.home_outlined,
                  title: 'Unit Terisi',
                  value: '$unitTerisi Unit',
                  iconColor: Colors.green,
                ),
                _buildSummaryCard(
                  icon: Icons.meeting_room_outlined,
                  title: 'Unit Kosong',
                  value: '$unitKosong Unit',
                  iconColor: Colors.amber,
                ),
                _buildSummaryCard(
                  icon: Icons.assignment_late_outlined,
                  title: 'Kontrak Kritis (H-7)',
                  value: '$kontrakAkanHabis Kontrak',
                  iconColor: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 5. DEMOGRAFI KATEGORI UMUR (Sesuai Aturan Klasifikasi Kemenkes RI)
            Text(
              'Kategori Demografi Umur Penghuni',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _activeColor),
            ),
            const SizedBox(height: 4),
            const Text(
              'Klasifikasi standar indikator data kelompok umur regulasi Perkim.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  _buildAgeProgressRow('Balita (0-5 tahun)', jmlBalita, totalPenghuni, Colors.red),
                  const SizedBox(height: 12),
                  _buildAgeProgressRow('Anak-anak (6-11 tahun)', jmlAnak, totalPenghuni, Colors.orange),
                  const SizedBox(height: 12),
                  _buildAgeProgressRow('Remaja (12-25 tahun)', jmlRemaja, totalPenghuni, Colors.blue),
                  const SizedBox(height: 12),
                  _buildAgeProgressRow('Dewasa (26-45 tahun)', jmlDewasa, totalPenghuni, Colors.green),
                  const SizedBox(height: 12),
                  _buildAgeProgressRow('Lansia (>45 tahun)', jmlLansia, totalPenghuni, Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6. DAFTAR PENDAFTAR BARU & JADWAL WAWANCARA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Antrean Wawancara Pendaftar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _activeColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: _activeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Saring Aktif',
                    style: TextStyle(color: _activeColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            daftarWawancara.isEmpty
                ? const Center(child: Text('Tidak ada jadwal wawancara terdekat.'))
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: daftarWawancara.length,
              itemBuilder: (context, index) {
                final pendaftar = daftarWawancara[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _activeColor.withOpacity(0.08),
                        child: Icon(Icons.assignment_ind_outlined, color: _activeColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pendaftar['nama']!,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _activeColor),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${pendaftar['tgl_wawancara']} • ${pendaftar['jam']}',
                              style: const TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Tujuan: ${pendaftar['lokasi_tujuan']}',
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu indikator Linear progress demografi kategori umur
  Widget _buildAgeProgressRow(String label, int value, int total, Color color) {
    double pct = total > 0 ? (value / total) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87)),
            Text('$value Jiwa (${(pct * 100).toStringAsFixed(1)}%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  // Komponen Reusable khusus Widget Card Informasi ringkas
  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _activeColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      ),
    );
  }
}