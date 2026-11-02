import 'package:flutter/material.dart';

// Import semua halaman latihan 1
import 'latihan1/masalah1.dart';
import 'latihan1/masalah2.dart';
import 'latihan1/masalah3.dart';
import 'latihan1/masalah4.dart';
import 'latihan1/masalah5.dart';
import 'latihan1/masalah6.dart';

// Import semua halaman latihan 2
import 'latihan2/masalah1.dart';
import 'latihan2/masalah2.dart';
import 'latihan2/masalah3.dart';
import 'latihan2/masalah4.dart';
import 'latihan2/masalah5.dart';
import 'latihan2/masalah6.dart';

// Import semua halaman latihan 3
import 'latihan3/masalah1.dart';
import 'latihan3/masalah2.dart';
import 'latihan3/masalah3.dart';
import 'latihan3/masalah4.dart';
import 'latihan3/masalah5.dart';

// Import semua halaman latihan 4
import 'latihan4/masalah1.dart';
import 'latihan4/masalah2.dart';
import 'latihan4/masalah3.dart';
import 'latihan4/masalah4.dart';
import 'latihan4/masalah5.dart';
import 'latihan4/masalah6.dart';

void main() => runApp(const PraktikumRouter());

/// Router utama untuk semua latihan dan masalah
class PraktikumRouter extends StatelessWidget {
  const PraktikumRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum Mobile - Pertemuan 4',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RouterPage(),
    );
  }
}

/// Halaman router dengan daftar semua latihan
class RouterPage extends StatelessWidget {
  const RouterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Pertemuan 4'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'HTTP, JSON, dan FutureBuilder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih latihan dan masalah yang ingin dijalankan:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Latihan 1: Permintaan HTTP Pertama & JSON Mentah
            _buildLatihanSection(
              context: context,
              title: 'Latihan 1: Permintaan HTTP Pertama & JSON Mentah',
              routes: [
                RouteItem('1. Verifikasi Koneksi API', const HalamanUjiApi()),
                RouteItem('2. Eksperimen Kategori API', const HalamanEksperimenKategori()),
                RouteItem('3. Penanganan Error: URL Rusak', const HalamanErrorHandling()),
                RouteItem('4. Kegunaan await', const HalamanAwaitDemo()),
                RouteItem('5. Penanganan Offline', const HalamanOfflineDemo()),
                RouteItem('6. State Management & try/setState', const HalamanStateManagement()),
              ],
            ),

            const SizedBox(height: 16),

            // Latihan 2: Model Class + ListView.builder
            _buildLatihanSection(
              context: context,
              title: 'Latihan 2: Model Class + ListView.builder',
              routes: [
                RouteItem('1. Dinamika Data Kategori', const HalamanKategori()),
                RouteItem('2. Field Null di filter.php', const HalamanKategoriNull()),
                RouteItem('3. Dynamic UI Counter AppBar', const HalamanKatalogCounter()),
                RouteItem('4. Penanganan Error Gambar', const HalamanErrorGambar()),
                RouteItem('5. Parsing factory fromJson', const HalamanFromJsonDemo()),
                RouteItem('6. Pull-to-Refresh Indicator', const HalamanRefreshIndicator()),
              ],
            ),

            const SizedBox(height: 16),

            // Latihan 3: Merapikan dengan FutureBuilder
            _buildLatihanSection(
              context: context,
              title: 'Latihan 3: Merapikan dengan FutureBuilder',
              routes: [
                RouteItem('1. Perbandingan Baris & Struktur Kode', const HalamanPerbandinganBarisKode()),
                RouteItem('2. Siklus ConnectionState (Lifecycle)', const HalamanSiklusConnectionState()),
                RouteItem('3. Bahaya Request di dalam build()', const HalamanBahayaBuildFetch()),
                RouteItem('4. Null Assertion snapshot.data! vs Fallback', const HalamanNullAssertionDemo()),
                RouteItem('5. Evaluasi: setState vs FutureBuilder', const HalamanKomparasiStateFuture()),
              ],
            ),

            const SizedBox(height: 16),

            // Latihan 4: Proyek Mini Katalog + Detail (Dua Endpoint)
            _buildLatihanSection(
              context: context,
              title: 'Latihan 4: Katalog + Detail (Dua Endpoint)',
              routes: [
                RouteItem('1. Katalog ke Detail Dua Endpoint', const HalamanKatalogDetailMini()),
                RouteItem('2. Validasi Null ID Resep (lookup.php)', const HalamanValidasiNullDetail()),
                RouteItem('3. Analisis: Passing ID vs Passing Object', const HalamanAnalisisPassingId()),
                RouteItem('4. Simpan ke Favorit (SnackBar)', const HalamanFavoritSnackBar()),
                RouteItem('5. Investigasi Field meal.kategori', const HalamanInvestigasiKategoriKatalog()),
                RouteItem('6. Animasi Transisi Hero (Nilai Tambah)', const HalamanHeroAnimationDemo()),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💡 Catatan: Setiap masalah berisi kode standalone yang bisa dijalankan secara independen. '
                'Untuk menjalankan satu latihan saja, ubah main() di file ini untuk langsung memanggil widget yang diinginkan.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk membuat section latihan
  Widget _buildLatihanSection({
    required BuildContext context,
    required String title,
    required List<RouteItem> routes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal.shade200),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),

        // Daftar route
        ...routes.map((route) => _buildRouteButton(context, route)),
        const SizedBox(height: 8),
      ],
    );
  }

  /// Helper untuk membuat tombol route
  Widget _buildRouteButton(BuildContext context, RouteItem route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => route.widget,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.code, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                route.title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Model untuk route item
class RouteItem {
  final String title;
  final Widget widget;

  const RouteItem(this.title, this.widget);
}
