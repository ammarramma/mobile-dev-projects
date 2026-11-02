import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config.dart';
import 'latihan1/masalah1.dart';
import 'latihan1/masalah2.dart';
import 'latihan1/masalah3.dart';
import 'latihan1/masalah4.dart';
import 'latihan1/masalah5.dart';
import 'latihan1/masalah6.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);

  runApp(const PraktikumRouter());
}

class PraktikumRouter extends StatelessWidget {
  const PraktikumRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum Mobile - Pertemuan 5',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const RouterPage(),
    );
  }
}

class RouterPage extends StatelessWidget {
  const RouterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final daftarTugas = <_TugasItem>[
      _TugasItem(
        judul: 'Tugas 1: SELECT Pertama',
        deskripsi: 'Menampilkan data dari tabel menu di Supabase',
        builder: (_) => const HalamanMasalah1(),
      ),
      _TugasItem(
        judul: 'Tugas 2: Ubah dari Table Editor',
        deskripsi: 'Mengubah nama menu lalu memuat ulang daftar',
        builder: (_) => const HalamanMasalah2(),
      ),
      _TugasItem(
        judul: 'Tugas 3: Baris Baru dari Dashboard',
        deskripsi: 'Menambah baris tanpa mengubah kode aplikasi',
        builder: (_) => const HalamanMasalah3(),
      ),
      _TugasItem(
        judul: 'Tugas 4: Kolom dibuat_pada',
        deskripsi: 'Memetakan timestamptz ke DateTime dan menampilkannya',
        builder: (_) => const HalamanMasalah4(),
      ),
      _TugasItem(
        judul: 'Tugas 5: Urutan Z-A',
        deskripsi: 'Mengubah pengurutan nama menjadi descending',
        builder: (_) => const HalamanMasalah5(),
      ),
      _TugasItem(
        judul: 'Tugas 6: Dua Perangkat',
        deskripsi: 'Membandingkan data pada dua perangkat',
        builder: (_) => const HalamanMasalah6(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Pertemuan 5'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Database Online dengan Supabase',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Latihan 1: Dari Dashboard ke Aplikasi - SELECT Pertama',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: const Text(
              'Pilih salah satu tugas di bawah. Setiap tugas membuka halaman '
              'yang membaca tabel menu secara langsung dari Supabase.',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ...daftarTugas.map((tugas) => _buildTombolTugas(context, tugas)),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Catatan: data tidak disimpan di dalam aplikasi. Perubahan dari '
            'Table Editor akan terlihat setelah tombol refresh ditekan.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTombolTugas(BuildContext context, _TugasItem tugas) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade50,
          child: const Icon(Icons.storage, color: Colors.teal),
        ),
        title: Text(
          tugas.judul,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(tugas.deskripsi),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: tugas.builder));
        },
      ),
    );
  }
}

class _TugasItem {
  const _TugasItem({
    required this.judul,
    required this.deskripsi,
    required this.builder,
  });

  final String judul;
  final String deskripsi;
  final WidgetBuilder builder;
}
