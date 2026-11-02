// Latihan 4 - Masalah 1: Proyek Mini Katalog & Detail Dua Endpoint
// Standalone widget: Katalog (filter.php) -> Detail (lookup.php) dengan passing idMeal & nama

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ---------------- ENDPOINT ----------------
const String urlDaftar = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood';
String urlDetail(String idMeal) => 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal';

// ---------------- MODEL ----------------
class Meal {
  final String id;
  final String nama;
  final String gambar;
  final String area;
  final String kategori;
  final String instruksi;

  const Meal({
    required this.id,
    required this.nama,
    required this.gambar,
    required this.area,
    required this.kategori,
    required this.instruksi,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String? ?? '',
      nama: json['strMeal'] as String? ?? 'Tanpa Nama',
      gambar: json['strMealThumb'] as String? ?? '',
      area: json['strArea'] as String? ?? 'Internasional',
      kategori: json['strCategory'] as String? ?? '-',
      instruksi: (json['strInstructions'] as String? ?? 'Belum ada instruksi.').replaceAll('\r\n', '\n'),
    );
  }
}

// ---------------- API SERVICES ----------------
Future<List<Meal>> ambilDaftarMeal() async {
  final response = await http.get(Uri.parse(urlDaftar)).timeout(const Duration(seconds: 10));
  if (response.statusCode != 200) {
    throw Exception('Server membalas status ${response.statusCode}');
  }
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final daftar = (data['meals'] as List<dynamic>?) ?? const [];
  return daftar.map((item) => Meal.fromJson(item as Map<String, dynamic>)).toList();
}

Future<Meal> ambilDetailMeal(String idMeal) async {
  final response = await http.get(Uri.parse(urlDetail(idMeal))).timeout(const Duration(seconds: 10));
  if (response.statusCode != 200) {
    throw Exception('Server membalas status ${response.statusCode}');
  }
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final daftar = data['meals'] as List<dynamic>?;
  if (daftar == null || daftar.isEmpty) {
    throw Exception('Detail resep tidak ditemukan');
  }
  return Meal.fromJson(daftar.first as Map<String, dynamic>);
}

Widget buildTampilanError(String pesan, VoidCallback onCobaLagi) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Gagal memuat data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(pesan, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onCobaLagi,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    ),
  );
}

// ---------------- HALAMAN KATALOG ----------------
class HalamanKatalogDetailMini extends StatefulWidget {
  const HalamanKatalogDetailMini({super.key});

  @override
  State<HalamanKatalogDetailMini> createState() => _HalamanKatalogDetailMiniState();
}

class _HalamanKatalogDetailMiniState extends State<HalamanKatalogDetailMini> {
  late Future<List<Meal>> futureMeal;

  @override
  void initState() {
    super.initState();
    futureMeal = ambilDaftarMeal();
  }

  void muatUlang() {
    setState(() {
      futureMeal = ambilDaftarMeal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 4 - Katalog Seafood'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Menu Utama',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: muatUlang,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: FutureBuilder<List<Meal>>(
        future: futureMeal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return buildTampilanError(snapshot.error.toString(), muatUlang);
          }

          final daftar = snapshot.data ?? [];
          if (daftar.isEmpty) {
            return const Center(child: Text('Tidak ada resep untuk kategori ini.'));
          }

          return RefreshIndicator(
            onRefresh: () async => muatUlang(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: daftar.length,
              itemBuilder: (context, index) {
                final meal = daftar[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        meal.gambar,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 64,
                          height: 64,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(
                      meal.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('ID: ${meal.id} - Tap untuk detail lengkap'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalamanDetailResep(
                            idMeal: meal.id,
                            nama: meal.nama,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ---------------- HALAMAN DETAIL ----------------
class HalamanDetailResep extends StatefulWidget {
  final String idMeal;
  final String nama;

  const HalamanDetailResep({super.key, required this.idMeal, required this.nama});

  @override
  State<HalamanDetailResep> createState() => _HalamanDetailResepState();
}

class _HalamanDetailResepState extends State<HalamanDetailResep> {
  late Future<Meal> futureDetail;

  @override
  void initState() {
    super.initState();
    futureDetail = ambilDetailMeal(widget.idMeal);
  }

  void muatUlang() {
    setState(() {
      futureDetail = ambilDetailMeal(widget.idMeal);
    });
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.teal),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.teal, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nama),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Meal>(
        future: futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return buildTampilanError(snapshot.error.toString(), muatUlang);
          }

          final meal = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  meal.gambar,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 220,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, size: 56, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(meal.nama, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          _chip(Icons.category, meal.kategori),
                          _chip(Icons.public, meal.area),
                          _chip(Icons.tag, meal.id),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Cara Membuat:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(meal.instruksi, style: const TextStyle(fontSize: 14, height: 1.5)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Kembali ke Katalog'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
