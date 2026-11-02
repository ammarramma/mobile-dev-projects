// Latihan 2 - Masalah 6: Pull-to-Refresh dengan RefreshIndicator
// Standalone widget

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Meal {
  final String id, nama, gambar, area;
  const Meal({
    required this.id,
    required this.nama,
    required this.gambar,
    required this.area,
  });
  factory Meal.fromJson(Map<String, dynamic> j) => Meal(
    id: j['idMeal'] as String? ?? '',
    nama: j['strMeal'] as String? ?? '',
    gambar: j['strMealThumb'] as String? ?? '',
    area: j['strArea'] as String? ?? '',
  );
}

Future<List<Meal>> ambilDaftar() async {
  final r = await http
      .get(
        Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood',
        ),
      )
      .timeout(const Duration(seconds: 10));
  if (r.statusCode != 200) throw Exception('Status ${r.statusCode}');
  final d = jsonDecode(r.body) as Map<String, dynamic>;
  return ((d['meals'] as List?) ?? [])
      .map((i) => Meal.fromJson(i as Map<String, dynamic>))
      .toList();
}

class HalamanRefreshIndicator extends StatefulWidget {
  const HalamanRefreshIndicator({super.key});
  @override
  State createState() => _State();
}

class _State extends State<HalamanRefreshIndicator> {
  late Future<List<Meal>> futureMeal;

  @override
  void initState() {
    super.initState();
    muatUlang();
  }

  Future<void> muatUlang() async {
    // Tahan selama 3 detik untuk menampilkan indikator refresh
    await Future.delayed(const Duration(seconds: 3));

    final dataBaru = ambilDaftar();
    setState(() {
      futureMeal = dataBaru;
    });
  }

  Widget buildImage(String url) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(
      url,
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 64,
        height: 64,
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 2 - Masalah 6: RefreshIndicator'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: muatUlang, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<List<Meal>>(
        future: futureMeal,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat...'),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: muatUlang,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          final daftar = snapshot.data ?? [];
          if (daftar.isEmpty) return const Center(child: Text('No data'));
          return RefreshIndicator(
            onRefresh: muatUlang,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: daftar.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: buildImage(daftar[i].gambar),
                  title: Text(
                    daftar[i].nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(daftar[i].area),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: muatUlang,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
