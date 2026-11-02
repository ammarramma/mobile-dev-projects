// Latihan 2 - Masalah 5: factory fromJson & Null Safety
// Standalone widget

import 'dart:convert';
import 'package:flutter/material.dart';

class MealBenar {
  final String id, nama, gambar, area;
  const MealBenar({required this.id, required this.nama, required this.gambar, required this.area});
  factory MealBenar.fromJson(Map<String, dynamic> j) => MealBenar(
    id: j['idMeal'] as String? ?? '',
    nama: j['strMeal'] as String? ?? 'Tanpa Nama',
    gambar: j['strMealThumb'] as String? ?? '',
    area: j['strArea'] as String? ?? 'Unknown',
  );
}

class MealSalah {
  final String id, nama, gambar, area;
  const MealSalah({required this.id, required this.nama, required this.gambar, required this.area});
  factory MealSalah.fromJson(Map<String, dynamic> j) => MealSalah(
    id: j['idMeal'] as String,
    nama: j['strMeal'] as String,
    gambar: j['strMealThumb'] as String,
    area: j['strArea'] as String,
  );
}

class HalamanFromJsonDemo extends StatefulWidget {
  const HalamanFromJsonDemo({super.key});
  @override
  State createState() => _State();
}

class _State extends State<HalamanFromJsonDemo> {
  String log = '';
  final jsonController = TextEditingController(text: '{"idMeal":"52772","strMeal":"Teriyaki Chicken","strMealThumb":"https://example.com/img.jpg","strArea":"Japanese"}');

  void testWithNullSafety() {
    try {
      final j = jsonDecode(jsonController.text) as Map<String, dynamic>;
      final m = MealBenar.fromJson(j);
      setState(() => log = 'SUKSES: ${m.nama}\nDengan ?? operator -> aman dari null');
    } catch (e) {
      setState(() => log = 'ERROR: $e');
    }
  }

  void testWithoutNullSafety() {
    try {
      final j = jsonDecode(jsonController.text) as Map<String, dynamic>;
      // Tambahkan null ke json untuk simulasi
      j['strMeal'] = null;
      final m = MealSalah.fromJson(j);
      setState(() => log = 'Tidak sampai sini!');
    } catch (e) {
      setState(() => log = 'CRASH!\n${e.toString().split('.').first}\nTanpa ?? -> crash saat field null');
    }
  }

  @override
  void dispose() {
    jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 2 - Masalah 5: fromJson'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Menu Utama',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: jsonController, maxLines: 3, decoration: const InputDecoration(labelText: 'JSON Input', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: testWithNullSafety, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('DENGAN ??'))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: testWithoutNullSafety, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('TANPA ??'))),
            ]),
            const SizedBox(height: 16),
            Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: SingleChildScrollView(child: Text(log.isEmpty ? 'Tekan tombol' : log))))),
            const Text('factory = Constructor dari JSON\n?? = Default value jika null\nTanpa ?? = Crash!', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
