// Latihan 2 - Masalah 1: Dinamika Data Berdasarkan Kategori
// Standalone widget

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Meal {
  final String id, nama, gambar, area;
  const Meal({required this.id, required this.nama, required this.gambar, required this.area});
  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    id: json['idMeal'] as String? ?? '',
    nama: json['strMeal'] as String? ?? 'Tanpa Nama',
    gambar: json['strMealThumb'] as String? ?? '',
    area: json['strArea'] as String? ?? 'Internasional',
  );
}

Future<List<Meal>> ambilDaftarMeal(String kategori) async {
  final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$kategori')).timeout(const Duration(seconds: 10));
  if (response.statusCode != 200) throw Exception('Status ${response.statusCode}');
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  return ((data['meals'] as List<dynamic>?) ?? const []).map((item) => Meal.fromJson(item as Map<String, dynamic>)).toList();
}

class HalamanKategori extends StatefulWidget {
  const HalamanKategori({super.key});
  @override
  State<HalamanKategori> createState() => _HalamanKategoriState();
}

class _HalamanKategoriState extends State<HalamanKategori> {
  bool sedangMemuat = true;
  String pesanError = '';
  List<Meal> daftarMeal = [];
  String kategoriTerpilih = 'Seafood';
  final List<String> categories = ['Seafood', 'Dessert', 'Chicken', 'Beef', 'Vegetarian', 'Pasta', 'Lamb'];

  @override
  void initState() {
    super.initState();
    muatData();
  }

  Future<void> muatData() async {
    setState(() => {sedangMemuat = true, pesanError = ''});
    try {
      daftarMeal = await ambilDaftarMeal(kategoriTerpilih);
      if (!mounted) return;
      setState(() => sedangMemuat = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => {pesanError = e.toString(), sedangMemuat = false});
    }
  }

  Widget _gambarMenu(String url) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(url, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: Colors.grey.shade200, child: const Icon(Icons.broken_image, color: Colors.grey))),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latihan 2 - Masalah 1: $kategoriTerpilih (${daftarMeal.length})'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Padding(padding: const EdgeInsets.only(right: 16), child: DropdownButton<String>(
            value: kategoriTerpilih,
            underline: Container(),
            items: categories.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) { if (v != null) setState(() => kategoriTerpilih = v); muatData(); },
          ))
        ],
      ),
      body: sedangMemuat ? const Center(child: CircularProgressIndicator()) :
        pesanError.isNotEmpty ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
          const SizedBox(height: 16),
          Text(pesanError),
          const SizedBox(height: 20),
          ElevatedButton.icon(onPressed: muatData, icon: const Icon(Icons.refresh), label: const Text('Coba Lagi'))
        ]))) :
        RefreshIndicator(
          onRefresh: muatData,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: daftarMeal.length,
            itemBuilder: (_, i) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(leading: _gambarMenu(daftarMeal[i].gambar), title: Text(daftarMeal[i].nama, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(daftarMeal[i].area), trailing: const Icon(Icons.chevron_right)),
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed: muatData, child: const Icon(Icons.refresh)),
    );
  }
}
