// Latihan 4 - Masalah 5: Investigasi Field meal.kategori di Katalog vs Detail
// Standalone widget: Menguji penampilan field meal.kategori pada endpoint filter.php vs lookup.php

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealItem {
  final String id, nama, gambar, kategori;

  const MealItem({
    required this.id,
    required this.nama,
    required this.gambar,
    required this.kategori,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      id: json['idMeal'] as String? ?? '',
      nama: json['strMeal'] as String? ?? 'Tanpa Nama',
      gambar: json['strMealThumb'] as String? ?? '',
      // Key strCategory di filter.php TIDAK ADA -> bernilai default '-'
      kategori: json['strCategory'] as String? ?? '-',
    );
  }
}

Future<List<MealItem>> ambilDaftarFilter() async {
  final res = await http
      .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'))
      .timeout(const Duration(seconds: 10));
  if (res.statusCode != 200) throw Exception('Status ${res.statusCode}');
  final data = jsonDecode(res.body) as Map<String, dynamic>;
  final list = (data['meals'] as List<dynamic>?) ?? const [];
  return list.map((item) => MealItem.fromJson(item as Map<String, dynamic>)).toList();
}

Future<String> ambilKategoriAsliDetail(String idMeal) async {
  final res = await http
      .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal'))
      .timeout(const Duration(seconds: 10));
  if (res.statusCode != 200) throw Exception('Status ${res.statusCode}');
  final data = jsonDecode(res.body) as Map<String, dynamic>;
  final list = data['meals'] as List<dynamic>?;
  if (list == null || list.isEmpty) return 'Tidak ditemukan';
  return (list.first['strCategory'] as String?) ?? '-';
}

class HalamanInvestigasiKategoriKatalog extends StatefulWidget {
  const HalamanInvestigasiKategoriKatalog({super.key});

  @override
  State<HalamanInvestigasiKategoriKatalog> createState() => _HalamanInvestigasiKategoriKatalogState();
}

class _HalamanInvestigasiKategoriKatalogState extends State<HalamanInvestigasiKategoriKatalog> {
  late Future<List<MealItem>> futureDaftar;

  @override
  void initState() {
    super.initState();
    futureDaftar = ambilDaftarFilter();
  }

  void _tampilkanModalDetail(MealItem meal) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final kategoriAsli = await ambilKategoriAsliDetail(meal.id);
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading dialog

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(meal.nama),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kategori di filter.php: "${meal.kategori}" (Default)'),
              const SizedBox(height: 8),
              Text(
                'Kategori di lookup.php: "$kategoriAsli" (Data Asli!)',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kesimpulan: Endpoint filter.php memang TIDAK menyediakan key strCategory di dalam respon JSON-nya.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 4 - Masalah 5: Field Kategori'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Menu Utama',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Banner Penjelasan
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.amber.shade50,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.amber, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Perhatikan label kategori pada setiap item katalog di bawah: '
                    'Isinya adalah "-" karena filter.php tidak mengirimkan strCategory. '
                    'Tap salah satu item untuk membuktikan bahwa lookup.php memiliki nilai kategori aslinya!',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: FutureBuilder<List<MealItem>>(
              future: futureDaftar,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final list = snapshot.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            item.gambar,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                          ),
                        ),
                        title: Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            const Text('Kategori: '),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '"${item.kategori}"',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Text(' (kosong)'),
                          ],
                        ),
                        trailing: const Icon(Icons.touch_app, size: 18),
                        onTap: () => _tampilkanModalDetail(item),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
