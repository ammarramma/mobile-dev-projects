// Latihan 3 - Masalah 3: Bahaya Memanggil Future di dalam build()
// Standalone widget: Membuktikan bahaya re-triggering request saat Future dibuat langsung di dalam build()

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Meal {
  final String id;
  final String nama;
  final String gambar;

  const Meal({required this.id, required this.nama, required this.gambar});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String? ?? '',
      nama: json['strMeal'] as String? ?? 'Tanpa Nama',
      gambar: json['strMealThumb'] as String? ?? '',
    );
  }
}

class HalamanBahayaBuildFetch extends StatefulWidget {
  const HalamanBahayaBuildFetch({super.key});

  @override
  State<HalamanBahayaBuildFetch> createState() => _HalamanBahayaBuildFetchState();
}

class _HalamanBahayaBuildFetchState extends State<HalamanBahayaBuildFetch> {
  bool modeBerbahaya = false;
  int jumlahPanggilanApi = 0;
  int rebuildCount = 0;
  late Future<List<Meal>> futureAman;

  @override
  void initState() {
    super.initState();
    futureAman = _fetchApiTracked();
  }

  Future<List<Meal>> _fetchApiTracked() async {
    jumlahPanggilanApi++;
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server status ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final daftar = (data['meals'] as List<dynamic>?) ?? const [];
    return daftar.map((item) => Meal.fromJson(item as Map<String, dynamic>)).toList();
  }

  void _triggerRebuild() {
    setState(() {
      rebuildCount++;
      if (!modeBerbahaya) {
        // Mode aman tidak mengubah futureAman
      }
    });
  }

  void _resetCounter() {
    setState(() {
      jumlahPanggilanApi = 0;
      rebuildCount = 0;
      futureAman = _fetchApiTracked();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan Future yang dipakai:
    // Mode berbahaya: memanggil _fetchApiTracked() LANGSUNG di build()
    // Mode aman: menggunakan futureAman yang diinisialisasi di initState()
    final Future<List<Meal>> targetFuture = modeBerbahaya ? _fetchApiTracked() : futureAman;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 3 - Masalah 3: Future di build()'),
        backgroundColor: modeBerbahaya ? Colors.red.shade700 : Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Menu Utama',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Banner Status & Mode Switcher
          Container(
            padding: const EdgeInsets.all(12),
            color: modeBerbahaya ? Colors.red.shade50 : Colors.teal.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      modeBerbahaya ? '⚠️ MODE: BERBAHAYA' : '✅ MODE: AMAN (Direkomendasikan)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: modeBerbahaya ? Colors.red.shade900 : Colors.teal.shade900,
                      ),
                    ),
                    Switch(
                      value: modeBerbahaya,
                      activeThumbColor: Colors.red,
                      onChanged: (val) {
                        setState(() {
                          modeBerbahaya = val;
                          _resetCounter();
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  modeBerbahaya
                      ? 'future: ambilDaftarMeal() dipanggil langsung di dalam build(). Setiap setState() memicu HTTP request baru tanpa henti!'
                      : 'future: futureMeal disimpan di variabel state (initState). HTTP request hanya dipanggil sekali.',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            const Text('Jumlah Request HTTP', style: TextStyle(fontSize: 11)),
                            Text(
                              '$jumlahPanggilanApi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: modeBerbahaya ? Colors.red : Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            const Text('Rebuild UI Triggered', style: TextStyle(fontSize: 11)),
                            Text(
                              '$rebuildCount',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.touch_app),
                        label: const Text('Trigger Rebuild (setState)'),
                        onPressed: _triggerRebuild,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _resetCounter,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Tampilan List dengan FutureBuilder
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: targetFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final list = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final meal = list[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(meal.gambar),
                      ),
                      title: Text(meal.nama),
                      subtitle: Text('Item #${index + 1}'),
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
