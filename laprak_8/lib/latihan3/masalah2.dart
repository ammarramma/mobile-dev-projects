// Latihan 3 - Masalah 2: Siklus ConnectionState pada FutureBuilder
// Standalone widget: Mencatat urutan ConnectionState saat FutureBuilder dieksekusi

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

Future<List<Meal>> ambilDaftarMeal() async {
  final response = await http
      .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'))
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception('Server membalas status ${response.statusCode}');
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final daftar = (data['meals'] as List<dynamic>?) ?? const [];
  return daftar.map((item) => Meal.fromJson(item as Map<String, dynamic>)).toList();
}

class HalamanSiklusConnectionState extends StatefulWidget {
  const HalamanSiklusConnectionState({super.key});

  @override
  State<HalamanSiklusConnectionState> createState() => _HalamanSiklusConnectionStateState();
}

class _HalamanSiklusConnectionStateState extends State<HalamanSiklusConnectionState> {
  late Future<List<Meal>> futureMeal;
  final List<String> logs = [];

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  void _muatData() {
    setState(() {
      logs.clear();
      futureMeal = ambilDaftarMeal();
    });
  }

  void _catatLog(ConnectionState state) {
    final pesan = '${DateTime.now().toIso8601String().substring(11, 19)} -> ConnectionState.$state';
    // Gunakan postFrameCallback agar tidak mengganggu proses build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && (logs.isEmpty || logs.last != pesan)) {
        setState(() {
          logs.add(pesan);
        });
      }
    });
    // Sesuai modul latihan 3 tugas 2: print ke console
    // ignore: avoid_print
    print('snapshot.connectionState: $state');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 3 - Masalah 2: ConnectionState'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Menu Utama',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _muatData,
            tooltip: 'Muat Ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          // Bagian Log & Penjelasan State
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blueGrey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.timeline, color: Colors.teal, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Riwayat snapshot.connectionState:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: logs.map((log) {
                    final isWaiting = log.contains('waiting');
                    return Chip(
                      avatar: CircleAvatar(
                        backgroundColor: isWaiting ? Colors.amber : Colors.green,
                        child: Icon(
                          isWaiting ? Icons.hourglass_top : Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      label: Text(
                        log,
                        style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Urutan: ConnectionState.waiting -> ConnectionState.done\n'
                  'waiting: Future sedang dieksekusi (tampilkan indikator loading)\n'
                  'done: Future telah selesai (sukses mengembalikan data atau error)',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // FutureBuilder dengan pemantau ConnectionState
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: futureMeal,
              builder: (context, snapshot) {
                _catatLog(snapshot.connectionState);

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Menunggu respon server (ConnectionState.waiting)...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error (ConnectionState.done): ${snapshot.error}'),
                  );
                }

                final daftar = snapshot.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: daftar.length,
                  itemBuilder: (context, index) {
                    final meal = daftar[index];
                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            meal.gambar,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                          ),
                        ),
                        title: Text(meal.nama),
                        subtitle: Text('ID: ${meal.id} (State: done)'),
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
