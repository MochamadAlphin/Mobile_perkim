import 'package:flutter/material.dart';
// Hubungkan ke file pendaftaran_pages agar kelas PendaftaranPages bisa dibaca langsung
import 'package:siraja/pages/pendaftar_pages.dart';

// =========================================================================
// 1. MODEL DATA (TETAP SAMA - TIDAK DIUBAH)
// =========================================================================
class RusunawaModel {
  final String id;
  final String name;
  final String location;
  final String price;
  final int availableUnits;
  final List<String> facilities;

  RusunawaModel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.availableUnits,
    required this.facilities,
  });

  factory RusunawaModel.fromJson(Map<String, dynamic> json) {
    return RusunawaModel(
      id: json['id'] ?? '',
      name: json['nama_rusunawa'] ?? '',
      location: json['alamat'] ?? '',
      price: json['harga'] ?? '0',
      availableUnits: json['sisa_unit'] ?? 0,
      facilities: List<String>.from(json['fasilitas'] ?? []),
    );
  }
}

// =========================================================================
// 2. MAIN WIDGET SCREEN (FLOATING PREMIUM CONTAINER WITH SYMMETRICAL GAPS)
// =========================================================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Master Palette Warna SIRAJA Balarea Premium
  final Color primaryColor = const Color(0xFF102E5A);
  final Color surfaceColor = const Color(0xFFF8FAFC);

  List<RusunawaModel> listRusunawa = [];

  @override
  void initState() {
    super.initState();
    _loadRusunawaData();
  }

  void _loadRusunawaData() {
    final mockDataFromApi = [
      {
        'id': '1',
        'nama_rusunawa': 'Rusunawa Limusnunggal',
        'alamat': 'Kp. Limusnunggal RT.001/003 Desa Limusnunggal, Kec. Cileungsi, Kab. Bogor',
        'harga': '200rb',
        'sisa_unit': 80,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '2',
        'nama_rusunawa': 'Rusun Pekerja Dayeuh',
        'alamat': 'Kp. Rawa Jamun RT.004/004 Desa Dayeuh, Kec. Cileungsi, Kab. Bogor',
        'harga': '520rb',
        'sisa_unit': 8,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '3',
        'nama_rusunawa': 'Rusunawa Cingised',
        'alamat': 'Jalan Cingised, Kelurahan Cisaranten Kulon, Kecamatan Arcamanik, Kota Bandung, Jawa Barat',
        'harga': '483 Unit',
        'sisa_unit': 483,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '4',
        'nama_rusunawa': 'Rumah Deret Tamansari',
        'alamat': 'Kawasan Rumah Deret Tamansari RW 11, Kelurahan Tamansari, Kecamatan Bandung Wetan, Kota Bandung, Jawa Barat',
        'harga': '0rb',
        'sisa_unit': 0,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '5',
        'nama_rusunawa': 'Rusunawa Jatisari',
        'alamat': 'Jatisari, Kec. Jatiasih, Kota Bekasi, Jawa Barat',
        'harga': '200rb',
        'sisa_unit': 108,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '6',
        'nama_rusunawa': 'Rusunawa Balegede',
        'alamat': 'Baleendah, Kec. Baleendah, Kabupaten Bandung, Jawa Barat',
        'harga': '250rb',
        'sisa_unit': 38,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
      {
        'id': '7',
        'nama_rusunawa': 'Rusunawa Cikuntul',
        'alamat': 'Kp. Cikuntul, Desa Cikuntul, Kec. Tempuran, Kab. Karawang, Jawa Barat',
        'harga': '175rb',
        'sisa_unit': 15,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Parkir Luas', 'Keamanan 24Jam']
      },
      {
        'id': '8',
        'nama_rusunawa': 'Rusunawa Pulogebang',
        'alamat': 'Jl. Sentra Primer Baru Timur, Pulo Gebang, Kec. Cakung, Jakarta Timur',
        'harga': '350rb',
        'sisa_unit': 42,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Sarana Olah Raga', 'Keamanan 24Jam', 'Klinik Kesehatan']
      },
      {
        'id': '9',
        'nama_rusunawa': 'Rusunawa Muara Baru',
        'alamat': 'Jl. Waduk Pluit, Penjaringan, Kec. Penjaringan, Jakarta Utara',
        'harga': '300rb',
        'sisa_unit': 0,
        'fasilitas': ['Area Terbuka Hijau', 'Aula', 'Keamanan 24Jam', 'Bebas Biaya Pendaftaran']
      },
    ];

    setState(() {
      listRusunawa = mockDataFromApi.map((e) => RusunawaModel.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          // 1. Background Image Full Screen
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_disperkim.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Soft Tint Overlay (Membantu kontras teks putih di atas)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.3),
          ),

          // 3. Main Interface Layout
          SafeArea(
            child: Column(
              children: [
                // Top Action Navigation Bar (Dibuat padat vertikal agar menghemat ruang bawaan logo besar)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                        ),
                      ),
                      // Mengunci tinggi space logo besar secara presisi dan membuang padding internal bawaan aset gambar
                      SizedBox(
                        height: 100,
                        width: 230,
                        child: Image.asset(
                          'assets/images/logo_siraja.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),

                // Header Teks Langsung Menempel Tanpa Gap Berlebih
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 16), // Dipersempit ke top: 4 & bottom: 16 agar rapat presisi
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pendaftaran Hunian',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Silakan pilih lokasi unit rusunawa aktif yang tersedia.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // FLOATING WHITE PANEL (Membentuk Box dengan Gap Sempurna di Kanan, Kiri, & Bawah)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 24), // Symmetrical Border Gaps
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(28), // Membulat penuh di semua sudut luar
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28), // Mengunci ripples & content dalam border radius
                      child: listRusunawa.isEmpty
                          ? Center(child: CircularProgressIndicator(color: primaryColor))
                          : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: listRusunawa.length,
                        itemBuilder: (context, index) {
                          return _buildPremiumCardItem(listRusunawa[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 3. ULTRA CLEAN INNER CARD COMPONENT (Rapi, Flat, Ringan & Berjarak Harmonis)
  // =========================================================================
  Widget _buildPremiumCardItem(RusunawaModel rusun) {
    bool isAvailable = rusun.availableUnits > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Judul Atas + Badge Kamar Terstruktur
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    rusun.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAvailable ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isAvailable ? '${rusun.availableUnits} Kamar' : 'Penuh',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: isAvailable ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Alamat dengan Icon Pin Berwarna Biru Sesuai Tema Aplikasi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.fmd_good_rounded, size: 13, color: primaryColor.withOpacity(0.7)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    rusun.location,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Garis Pemisah Internal Tipis Eksklusif
            Container(height: 1, color: const Color(0xFFF1F5F9)),
            const SizedBox(height: 10),

            // Sesi Bawah: Harga Sewa & Tombol Aksi Sejajar Presisi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Komponen Nilai Rupiah / Unit
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TARIF SEWA',
                      style: TextStyle(
                        fontSize: 8,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          rusun.price.contains('Unit') ? rusun.price : 'Rp ${rusun.price}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                        if (!rusun.price.contains('Unit'))
                          const Text(
                            ' / bln',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                // Tombol Aksi "Pilih Unit"
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: isAvailable
                        ? () {
                      // FIX: Menampilkan pendaftar_pages.dart langsung sebagai pop-up Bottom Sheet
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // Memastikan pop-up naik ketika keyboard muncul
                        backgroundColor: Colors.transparent, // Mengikuti sudut dekorasi bawaan file pendaftar_pages
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.85, // Membatasi tinggi pop-up agar rapi
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                              child: const PendaftaranPages(),
                            ),
                          );
                        },
                        routeSettings: RouteSettings(
                          arguments: {
                            'id_rusunawa': rusun.id,
                            'nama_rusunawa': rusun.name,
                          },
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      disabledBackgroundColor: const Color(0xFFF1F5F9),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Pilih Unit',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isAvailable ? Colors.white : const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 14,
                          color: isAvailable ? Colors.white : const Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}