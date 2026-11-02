import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config.dart';
import 'latihan1/masalah1.dart';
import 'latihan1/masalah2.dart';
import 'latihan1/masalah3.dart';
import 'latihan1/masalah4.dart';
import 'latihan1/masalah5.dart';
import 'latihan1/masalah6.dart';
import 'latihan2/masalah1.dart';
import 'latihan2/masalah2.dart';
import 'latihan2/masalah3.dart';
import 'latihan2/masalah4.dart';
import 'latihan2/masalah5.dart';
import 'latihan2/masalah6.dart';

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
            'Latihan 1: SELECT Pertama  |  Latihan 2: INSERT',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            judul: 'Latihan 1: SELECT Pertama',
            tugas: const [
              _TugasItem(
                '1.1 SELECT Pertama',
                'Menampilkan data dari tabel menu di Supabase',
                HalamanMasalah1(),
              ),
              _TugasItem(
                '1.2 Ubah dari Table Editor',
                'Mengubah nama menu lalu memuat ulang daftar',
                HalamanMasalah2(),
              ),
              _TugasItem(
                '1.3 Baris Baru dari Dashboard',
                'Menambah baris tanpa mengubah kode aplikasi',
                HalamanMasalah3(),
              ),
              _TugasItem(
                '1.4 Kolom dibuat_pada',
                'Memetakan timestamptz ke DateTime dan menampilkannya',
                HalamanMasalah4(),
              ),
              _TugasItem(
                '1.5 Urutan Z-A',
                'Mengubah pengurutan nama menjadi descending',
                HalamanMasalah5(),
              ),
              _TugasItem(
                '1.6 Dua Perangkat',
                'Membandingkan data pada dua perangkat',
                HalamanMasalah6(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            judul: 'Latihan 2: Menambah Data dengan INSERT',
            tugas: const [
              _TugasItem(
                '2.1 Menu Baru dari Aplikasi',
                'Menyimpan menu baru lalu memeriksa Table Editor',
                HalamanInsert1(),
              ),
              _TugasItem(
                '2.2 Nilai Default Kolom Baru',
                'Memeriksa id, tersedia, dan dibuat_pada',
                HalamanInsert2(),
              ),
              _TugasItem(
                '2.3 Validasi Harga Teks',
                'Menolak harga non-angka sebelum INSERT',
                HalamanInsert3(),
              ),
              _TugasItem(
                '2.4 Penanganan Error INSERT',
                'Menguji try/catch saat koneksi gagal',
                HalamanInsert4(),
              ),
              _TugasItem(
                '2.5 Validasi Deskripsi',
                'Membatasi deskripsi maksimal 100 karakter',
                HalamanInsert5(),
              ),
              _TugasItem(
                '2.6 Navigator.push<bool>',
                'Menerima nilai kembali dari halaman form',
                HalamanInsert6(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Setiap tugas membuka halaman yang membaca atau menulis tabel menu '
            'secara langsung ke Supabase.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String judul,
    required List<_TugasItem> tugas,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal.shade200),
          ),
          child: Text(
            judul,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        ...tugas.map((item) => _buildTombolTugas(context, item)),
      ],
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => tugas.halaman),
          );
        },
      ),
    );
  }
}

class _TugasItem {
  const _TugasItem(this.judul, this.deskripsi, this.halaman);

  final String judul;
  final String deskripsi;
  final Widget halaman;
}
