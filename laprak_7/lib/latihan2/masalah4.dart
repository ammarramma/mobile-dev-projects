// Latihan 2 - Masalah 4: Penanganan Error Gambar
// Standalone widget

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Meal {
  final String id, nama, gambar, area;
  const Meal({required this.id, required this.nama, required this.gambar, required this.area});
  factory Meal.fromJson(Map<String, dynamic> j) => Meal(
    id: j['idMeal'] as String? ?? '',
    nama: j['strMeal'] as String? ?? '',
    gambar: j['strMealThumb'] as String? ?? '',
    area: j['strArea'] as String? ?? '',
  );
}

Future<List<Meal>> ambilDaftar() async {
  final r = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood')).timeout(const Duration(seconds: 10));
  if (r.statusCode != 200) throw Exception('Status ${r.statusCode}');
  final d = jsonDecode(r.body) as Map<String, dynamic>;
  return ((d['meals'] as List?) ?? []).map((i) => Meal.fromJson(i as Map<String, dynamic>)).toList();
}

class HalamanErrorGambar extends StatefulWidget {
  const HalamanErrorGambar({super.key});
  @override
  State createState() => _State();
}

class _State extends State<HalamanErrorGambar> {
  bool loading = true; String error = ''; List<Meal> meals = [];
  bool useErrorBuilder = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => {loading = true, error = ''});
    try {
      meals = await ambilDaftar();
      if (!mounted) return;
      setState(() => loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => {error = e.toString(), loading = false});
    }
  }

  void addBadUrl() {
    setState(() => meals = [Meal(id: 'bad', nama: 'Bad URL Test', gambar: 'https://invalid-url-xyz.com/image.jpg', area: 'Test'), ...meals]);
  }

  Widget buildImage(String url) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(url, width: 64, height: 64, fit: BoxFit.cover,
      errorBuilder: useErrorBuilder ? (_, __, ___) => Container(width: 64, height: 64, color: Colors.grey.shade200, child: const Icon(Icons.broken_image, color: Colors.grey)) : null),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 2 - Masalah 4: Error Gambar'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Switch(value: useErrorBuilder, onChanged: (v) => setState(() => useErrorBuilder = v)),
          const Text('errorBuilder'),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: addBadUrl, child: const Text('Tambah URL Salah')),
          Expanded(child: loading ? const Center(child: CircularProgressIndicator()) :
            error.isNotEmpty ? Center(child: Text(error)) :
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: meals.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: buildImage(meals[i].gambar),
                  title: Text(meals[i].nama),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(meals[i].area), if (meals[i].gambar.contains('invalid')) const Text('⚠️ URL Salah!', style: TextStyle(color: Colors.red, fontSize: 10))]),
                ),
              ),
            )),
          ElevatedButton(onPressed: load, child: const Text('Muat Ulang')),
        ],
      ),
    );
  }
}
