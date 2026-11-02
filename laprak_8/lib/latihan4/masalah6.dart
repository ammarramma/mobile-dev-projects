// Latihan 4 - Masalah 6 (Nilai Tambah): Animasi Transisi Hero
// Standalone widget: Mengimplementasikan animasi transisi shared element Hero antara Katalog & Detail

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealHero {
  final String id, nama, gambar;
  const MealHero({required this.id, required this.nama, required this.gambar});
  factory MealHero.fromJson(Map<String, dynamic> j) => MealHero(
        id: j['idMeal'] as String? ?? '',
        nama: j['strMeal'] as String? ?? 'Tanpa Nama',
        gambar: j['strMealThumb'] as String? ?? '',
      );
}

Future<List<MealHero>> ambilKatalogHero() async {
  final res = await http
      .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'))
      .timeout(const Duration(seconds: 10));
  if (res.statusCode != 200) throw Exception('Status ${res.statusCode}');
  final data = jsonDecode(res.body) as Map<String, dynamic>;
  final list = (data['meals'] as List<dynamic>?) ?? const [];
  return list.map((item) => MealHero.fromJson(item as Map<String, dynamic>)).toList();
}

class HalamanHeroAnimationDemo extends StatefulWidget {
  const HalamanHeroAnimationDemo({super.key});

  @override
  State<HalamanHeroAnimationDemo> createState() => _HalamanHeroAnimationDemoState();
}

class _HalamanHeroAnimationDemoState extends State<HalamanHeroAnimationDemo> {
  late Future<List<MealHero>> futureHero;

  @override
  void initState() {
    super.initState();
    futureHero = ambilKatalogHero();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 4 - Masalah 6: Hero Animation'),
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
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.teal.shade50,
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.teal),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hero Animation menghubungkan thumbnail gambar di katalog dengan gambar besar di halaman detail menggunakan tag yang sama (tag: meal.id). Animasi diperlambat menjadi 3 detik untuk memudahkan screenshot.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<MealHero>>(
              future: futureHero,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final list = snapshot.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final meal = list[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        // 1. Hero Widget di Halaman Katalog
                        leading: Hero(
                          tag: 'hero-meal-${meal.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              meal.gambar,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        title: Text(meal.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Tap untuk melihat animasi Hero terbang!'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            SlowHeroRoute(
                              builder: (ctx) => HalamanDetailHeroView(meal: meal),
                            ),
                          );
                        },
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

// Custom Route with longer transition duration for slower Hero animation
class SlowHeroRoute<T> extends MaterialPageRoute<T> {
  SlowHeroRoute({
    required super.builder,
    super.settings,
  });

  @override
  Duration get transitionDuration => const Duration(seconds: 3);
}

class HalamanDetailHeroView extends StatelessWidget {
  final MealHero meal;

  const HalamanDetailHeroView({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.nama),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 2. Hero Widget di Halaman Detail dengan tag yang sama
            Hero(
              tag: 'hero-meal-${meal.id}',
              child: Image.network(
                meal.gambar,
                height: 260,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 260,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 60),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.nama,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('ID Resep: ${meal.id}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Animasi transisi gambar meluncur mulus dari thumbnail ke gambar besar!',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali (Hero Reverse Animation)'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
