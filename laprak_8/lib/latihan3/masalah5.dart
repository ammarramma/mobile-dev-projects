// Latihan 3 - Masalah 5: Evaluasi Pendekatan: setState vs FutureBuilder
// Standalone widget: Memberikan komparasi mendalam untuk penentuan arsitektur Tugas Mandiri

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Meal {
  final String id, nama, gambar;
  const Meal({required this.id, required this.nama, required this.gambar});
  factory Meal.fromJson(Map<String, dynamic> j) => Meal(
        id: j['idMeal'] as String? ?? '',
        nama: j['strMeal'] as String? ?? 'Tanpa Nama',
        gambar: j['strMealThumb'] as String? ?? '',
      );
}

Future<List<Meal>> ambilDaftarMeal() async {
  final response = await http
      .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'))
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception('Server error: ${response.statusCode}');
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final list = (data['meals'] as List<dynamic>?) ?? const [];
  return list.map((item) => Meal.fromJson(item as Map<String, dynamic>)).toList();
}

class HalamanKomparasiStateFuture extends StatefulWidget {
  const HalamanKomparasiStateFuture({super.key});

  @override
  State<HalamanKomparasiStateFuture> createState() => _HalamanKomparasiStateFutureState();
}

class _HalamanKomparasiStateFutureState extends State<HalamanKomparasiStateFuture> {
  int tabTerpilih = 0; // 0: FutureBuilder, 1: setState

  // State untuk demonstrasi pendekatan setState manual
  bool sedangMemuatSetState = false;
  String pesanErrorSetState = '';
  List<Meal> listSetState = [];

  // State untuk demonstrasi FutureBuilder
  late Future<List<Meal>> futureMeal;

  @override
  void initState() {
    super.initState();
    futureMeal = ambilDaftarMeal();
    _muatDataSetState();
  }

  Future<void> _muatDataSetState() async {
    setState(() {
      sedangMemuatSetState = true;
      pesanErrorSetState = '';
    });
    try {
      final res = await ambilDaftarMeal();
      if (!mounted) return;
      setState(() {
        listSetState = res;
        sedangMemuatSetState = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        pesanErrorSetState = e.toString();
        sedangMemuatSetState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 3 - Masalah 5: Evaluasi Pendekatan'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Menu Utama',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Ringkasan Jawaban Tugas 5
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.teal.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.rate_review, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          'Pilihan untuk Tugas Mandiri:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pilihan Terbaik: Pendekatan FutureBuilder.\n\n'
                      'Alasan (3-4 baris):\n'
                      '1. FutureBuilder secara deklaratif dan otomatis mengelola transisi 3 keadaan (waiting, error, data) lewat AsyncSnapshot tanpa perlu 3 variabel state terpisah.\n'
                      '2. Menghilangkan kode try-catch manual dan pengecekan if (!mounted) return di banyak tempat.\n'
                      '3. Kode jauh lebih ringkas, rapi, dan mudah dikombinasikan dengan RefreshIndicator untuk Tugas Mandiri.',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tabel Komparasi Fitur
            const Text(
              'Tabel Komparasi Head-to-Head:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  children: const [
                    Padding(padding: EdgeInsets.all(8), child: Text('Kriteria', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8), child: Text('setState Manual', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8), child: Text('FutureBuilder', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('Boilerplate')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Tinggi (3 variabel)')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Rendah (1 variabel)')),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('Error Handling')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Manual try/catch')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Otomatis via snapshot.hasError')),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('Aksi Tombol/Form')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Sangat fleksibel')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Perlu re-assign future')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Live Demo Komparasi Interaktif
            const Text(
              'Uji Coba Demo Kedua Pendekatan:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('FutureBuilder')),
                ButtonSegment(value: 1, label: Text('setState Manual')),
              ],
              selected: {tabTerpilih},
              onSelectionChanged: (val) {
                setState(() {
                  tabTerpilih = val.first;
                });
              },
            ),
            const SizedBox(height: 12),
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: tabTerpilih == 0
                  ? FutureBuilder<List<Meal>>(
                      future: futureMeal,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        final items = snapshot.data ?? [];
                        return ListView.builder(
                          itemCount: items.take(5).length,
                          itemBuilder: (ctx, idx) => ListTile(
                            title: Text(items[idx].nama),
                            subtitle: const Text('Dimuat via FutureBuilder'),
                          ),
                        );
                      },
                    )
                  : sedangMemuatSetState
                      ? const Center(child: CircularProgressIndicator())
                      : pesanErrorSetState.isNotEmpty
                          ? Center(child: Text(pesanErrorSetState))
                          : ListView.builder(
                              itemCount: listSetState.take(5).length,
                              itemBuilder: (ctx, idx) => ListTile(
                                title: Text(listSetState[idx].nama),
                                subtitle: const Text('Dimuat via setState manual'),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
