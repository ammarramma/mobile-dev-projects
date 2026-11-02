// Latihan 2 - Masalah 2: Field Null di filter.php
// Standalone widget - filter.php tidak punya strCategory

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Meal {
  final String id, nama, gambar, area;
  final String? kategori;
  const Meal({required this.id, required this.nama, required this.gambar, required this.area, this.kategori});
  factory Meal.fromJson(Map<String, dynamic> j) => Meal(
    id: j['idMeal'] as String? ?? '',
    nama: j['strMeal'] as String? ?? 'Tanpa Nama',
    gambar: j['strMealThumb'] as String? ?? '',
    area: j['strArea'] as String? ?? 'Internasional',
    kategori: j['strCategory'] as String?, // NULL di filter.php!
  );
}

Future<List<Meal>> ambilDaftar() async {
  final r = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood')).timeout(const Duration(seconds: 10));
  if (r.statusCode != 200) throw Exception('Status ${r.statusCode}');
  final d = jsonDecode(r.body) as Map<String, dynamic>;
  return ((d['meals'] as List?) ?? []).map((i) => Meal.fromJson(i as Map<String, dynamic>)).toList();
}

class HalamanKategoriNull extends StatefulWidget {
  const HalamanKategoriNull({super.key});
  @override
  State createState() => _State();
}

class _State extends State<HalamanKategoriNull> {
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
        title: const Text('Latihan 2 - Masalah 2: Null Field'),
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
          Container(color: Colors.red.shade50, padding: const EdgeInsets.all(8), child: const Text('filter.php HANYA: idMeal, strMeal, strMealThumb, strArea\nTIDAK ADA strCategory!', style: TextStyle(color: Colors.red), textAlign: TextAlign.center)),
          Expanded(child: loading ? const Center(child: CircularProgressIndicator()) :
            error.isNotEmpty ? Center(child: Text(error)) :
            ListView.builder(
              itemCount: meals.length,
              itemBuilder: (_, i) => ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(meals[i].gambar), radius: 24),
                title: Text(meals[i].nama),
                subtitle: Text('${meals[i].area} | Kategori: ${meals[i].kategori ?? "NULL"}'),
              ),
            )
          ),
          ElevatedButton(onPressed: load, child: const Text('Muat Ulang')),
        ],
      ),
    );
  }
}
