// Latihan 3 - Masalah 1: Perbandingan Struktur & Baris Kode
// Standalone widget: Membandingkan _HalamanKatalogState pada Latihan 2 (setState) vs Latihan 3 (FutureBuilder)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Meal {
  final String id;
  final String nama;
  final String gambar;
  final String area;

  const Meal({
    required this.id,
    required this.nama,
    required this.gambar,
    required this.area,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String? ?? '',
      nama: json['strMeal'] as String? ?? 'Tanpa Nama',
      gambar: json['strMealThumb'] as String? ?? '',
      area: json['strArea'] as String? ?? 'Internasional',
    );
  }
}

Future<List<Meal>> ambilDaftarMeal() async {
  final response = await http
      .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'))
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception('Server membalas status ${response.statusCode}');
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final daftar = (data['meals'] as List<dynamic>?) ?? const [];
  return daftar.map((item) => Meal.fromJson(item as Map<String, dynamic>)).toList();
}

class HalamanPerbandinganBarisKode extends StatefulWidget {
  const HalamanPerbandinganBarisKode({super.key});

  @override
  State<HalamanPerbandinganBarisKode> createState() => _HalamanPerbandinganBarisKodeState();
}

class _HalamanPerbandinganBarisKodeState extends State<HalamanPerbandinganBarisKode>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 3 - Masalah 1: Perbandingan Kode'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Menu Utama',
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.teal.shade100,
          tabs: const [
            Tab(icon: Icon(Icons.code), text: 'Ringkasan & Selisih'),
            Tab(icon: Icon(Icons.compare_arrows), text: 'Live Demo'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnalisisTab(),
          _buildLiveDemoTab(),
        ],
      ),
    );
  }

  Widget _buildAnalisisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Analisis Jumlah Baris Kode',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Perbandingan implementasi class _HalamanKatalogState antara Latihan 2 dan Latihan 3:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1.2),
                      2: FlexColumnWidth(1.2),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.teal.shade50),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('Aspek', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('Latihan 2 (setState)', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('Latihan 3 (FutureBuilder)', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const TableRow(
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: Text('Variabel State')),
                          Padding(padding: EdgeInsets.all(8), child: Text('3 variabel\n(loading, error, list)')),
                          Padding(padding: EdgeInsets.all(8), child: Text('1 variabel\n(futureMeal)')),
                        ],
                      ),
                      const TableRow(
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: Text('Metode muat data')),
                          Padding(padding: EdgeInsets.all(8), child: Text('~25 baris\n(try-catch + 2x setState)')),
                          Padding(padding: EdgeInsets.all(8), child: Text('~5 baris\n(re-assign future)')),
                        ],
                      ),
                      const TableRow(
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: Text('Pengondisian UI')),
                          Padding(padding: EdgeInsets.all(8), child: Text('Ternary nested di build()')),
                          Padding(padding: EdgeInsets.all(8), child: Text('snapshot handler di FutureBuilder')),
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: Colors.amber.shade50),
                        children: const [
                          Padding(padding: EdgeInsets.all(8), child: Text('Total Baris State', style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text('~65 baris', style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text('~40 baris (Hemat ~38%)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.teal.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Kesimpulan Tugas 1:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'FutureBuilder memangkas kode boilerplate pengelolaan state loading dan error secara signifikan. '
                    'Single Source of Truth berada langsung pada objek snapshot Future, bukan variabel boolean/string yang harus disinkronkan manual.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDemoTab() {
    return FutureBuilder<List<Meal>>(
      future: ambilDaftarMeal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final list = snapshot.data ?? [];
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final meal = list[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  meal.gambar,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                ),
              ),
              title: Text(meal.nama),
              subtitle: Text('ID: ${meal.id} - ${meal.area}'),
            );
          },
        );
      },
    );
  }
}
