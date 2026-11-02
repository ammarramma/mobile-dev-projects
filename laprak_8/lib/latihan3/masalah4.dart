// Latihan 3 - Masalah 4: Null Assertion snapshot.data! vs Fallback ?? []
// Standalone widget: Menjelaskan kapan penggunaan bang operator (!) menyebabkan runtime error

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Meal {
  final String id;
  final String nama;

  const Meal({required this.id, required this.nama});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String? ?? '',
      nama: json['strMeal'] as String? ?? 'Tanpa Nama',
    );
  }
}

Future<List<Meal>> ambilDaftarMeal() async {
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

class HalamanNullAssertionDemo extends StatefulWidget {
  const HalamanNullAssertionDemo({super.key});

  @override
  State<HalamanNullAssertionDemo> createState() => _HalamanNullAssertionDemoState();
}

class _HalamanNullAssertionDemoState extends State<HalamanNullAssertionDemo> {
  bool gunakanForceUnwrap = false; // Jika true: simulasi snapshot.data!
  late Future<List<Meal>> futureMeal;

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  void _muatUlang() {
    setState(() {
      futureMeal = ambilDaftarMeal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 3 - Masalah 4: snapshot.data!'),
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
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: Column(
        children: [
          // Kontrol Simulasi & Penjelasan
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.amber.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gunakan snapshot.data! (Force Unwrap):',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Switch(
                      value: gunakanForceUnwrap,
                      activeThumbColor: Colors.deepOrange,
                      onChanged: (val) {
                        setState(() {
                          gunakanForceUnwrap = val;
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  gunakanForceUnwrap
                      ? '⚠️ PERINGATAN: Memaksa akses snapshot.data! saat data masih null (fase loading atau error) '
                          'akan melempar Null check operator used on a null value.'
                      : '✅ AMAN: snapshot.data ?? [] menyediakan fallback default list kosong jika snapshot belum memiliki data.',
                  style: TextStyle(
                    fontSize: 12,
                    color: gunakanForceUnwrap ? Colors.deepOrange.shade900 : Colors.teal.shade900,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // FutureBuilder dengan penanganan demonstratif
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: futureMeal,
              builder: (context, snapshot) {
                // Jika user mengaktifkan force unwrap dan mencoba mengakses data sebelum selesai:
                if (gunakanForceUnwrap) {
                  try {
                    // Sengaja memicu unwrap tanpa mengecek waiting / hasError
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      final dangerousList = snapshot.data!; // Akan melempar exception!
                      return Text('Items: ${dangerousList.length}');
                    }
                  } catch (e) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Card(
                          color: Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                                const SizedBox(height: 8),
                                const Text(
                                  'CRASH TERTANGKAP!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$e',
                                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Penyebab: snapshot.data bernilai null selama ConnectionState.waiting atau hasError.',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }

                // Pola Standar & Aman
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Cara aman dengan fallback operator
                final daftar = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: daftar.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(daftar[index].nama),
                      subtitle: Text('ID: ${daftar[index].id}'),
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
