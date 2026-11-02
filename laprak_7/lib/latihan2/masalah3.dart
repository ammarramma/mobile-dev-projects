// Latihan 2 - Masalah 3: Dynamic UI - Count di AppBar
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
  final r = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Chicken')).timeout(const Duration(seconds: 10));
  if (r.statusCode != 200) throw Exception('Status ${r.statusCode}');
  final d = jsonDecode(r.body) as Map<String, dynamic>;
  return ((d['meals'] as List?) ?? []).map((i) => Meal.fromJson(i as Map<String, dynamic>)).toList();
}

class HalamanKatalogCounter extends StatefulWidget {
  const HalamanKatalogCounter({super.key});
  @override
  State createState() => _State();
}

class _State extends State<HalamanKatalogCounter> {
  bool loading = true; String error = ''; List<Meal> meals = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Dynamic count di title
        title: Text('Katalog (${meals.length})'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) :
        error.isNotEmpty ? Center(child: Text(error)) :
        RefreshIndicator(
          onRefresh: load,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: meals.length,
            itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(meals[i].gambar, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))),
                title: Text(meals[i].nama),
                subtitle: Text(meals[i].area),
              ),
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => meals = [...meals, Meal(id: 'd${DateTime.now().millisecondsSinceEpoch}', nama: 'Dummy ${meals.length+1}', gambar: 'https://via.placeholder.com/150', area: 'Test')]),
        child: const Text('+'),
      ),
    );
  }
}
