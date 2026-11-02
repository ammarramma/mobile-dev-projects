// Latihan 4 - Masalah 4: Simpan ke Favorit dengan SnackBar
// Standalone widget: Halaman Detail yang dilengkapi fitur toggle Simpan ke Favorit via SnackBar

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealDetail {
  final String id, nama, gambar, kategori, area, instruksi;
  const MealDetail({
    required this.id,
    required this.nama,
    required this.gambar,
    required this.kategori,
    required this.area,
    required this.instruksi,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    return MealDetail(
      id: json['idMeal'] as String? ?? '',
      nama: json['strMeal'] as String? ?? 'Tanpa Nama',
      gambar: json['strMealThumb'] as String? ?? '',
      kategori: json['strCategory'] as String? ?? '-',
      area: json['strArea'] as String? ?? 'Internasional',
      instruksi: (json['strInstructions'] as String? ?? 'Belum ada instruksi.').replaceAll('\r\n', '\n'),
    );
  }
}

Future<MealDetail> ambilDetailMeal(String id) async {
  final res = await http
      .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'))
      .timeout(const Duration(seconds: 10));

  if (res.statusCode != 200) throw Exception('Status ${res.statusCode}');
  final data = jsonDecode(res.body) as Map<String, dynamic>;
  final list = data['meals'] as List<dynamic>?;
  if (list == null || list.isEmpty) throw Exception('Resep tidak ditemukan');
  return MealDetail.fromJson(list.first as Map<String, dynamic>);
}

class HalamanFavoritSnackBar extends StatefulWidget {
  const HalamanFavoritSnackBar({super.key});

  @override
  State<HalamanFavoritSnackBar> createState() => _HalamanFavoritSnackBarState();
}

class _HalamanFavoritSnackBarState extends State<HalamanFavoritSnackBar> {
  final String idResep = '52772'; // Baked Salmon
  late Future<MealDetail> futureMeal;
  bool isFavorit = false;

  @override
  void initState() {
    super.initState();
    futureMeal = ambilDetailMeal(idResep);
  }

  void _toggleFavorit(String namaResep) {
    setState(() {
      isFavorit = !isFavorit;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isFavorit ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isFavorit
                    ? '$namaResep berhasil disimpan ke Favorit!'
                    : '$namaResep dihapus dari Favorit.',
              ),
            ),
          ],
        ),
        backgroundColor: isFavorit ? Colors.teal.shade700 : Colors.blueGrey,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'BATALKAN',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              isFavorit = !isFavorit;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 4 - Masalah 4: SnackBar Favorit'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Menu Utama',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<MealDetail>(
        future: futureMeal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final meal = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Image.network(
                      meal.gambar,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 220,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: FloatingActionButton.small(
                        backgroundColor: Colors.white,
                        onPressed: () => _toggleFavorit(meal.nama),
                        child: Icon(
                          isFavorit ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              meal.nama,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isFavorit ? Colors.red.shade50 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isFavorit ? 'Favorit ❤️' : 'Bukan Favorit',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isFavorit ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _toggleFavorit(meal.nama),
                        icon: Icon(isFavorit ? Icons.favorite : Icons.favorite_border),
                        label: Text(isFavorit ? 'Hapus dari Favorit' : 'Simpan ke Favorit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFavorit ? Colors.red.shade600 : Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const Text('Cara Membuat:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(meal.instruksi, style: const TextStyle(fontSize: 13, height: 1.5)),
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
