// Latihan 1 - Masalah 2: Eksperimen Kategori API
// Standalone widget - gunakan di router dengan MaterialApp

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Variabel yang bisa diubah untuk ganti kategori
String kategoriTerpilih = 'Seafood';
const List<String> daftarKategori = ['Seafood', 'Dessert', 'Chicken', 'Beef', 'Vegetarian'];

// Widget utama untuk Masalah 2
class HalamanEksperimenKategori extends StatefulWidget {
  const HalamanEksperimenKategori({super.key});

  @override
  State<HalamanEksperimenKategori> createState() => _HalamanEksperimenKategoriState();
}

class _HalamanEksperimenKategoriState extends State<HalamanEksperimenKategori> {
  bool sedangMemuat = true;
  String pesan = '';
  int jumlahItem = 0;

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  Future<void> ambilData() async {
    setState(() {
      sedangMemuat = true;
      pesan = '';
    });

    try {
      final url = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=$kategoriTerpilih';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final daftar = (data['meals'] as List<dynamic>?) ?? const [];
        
        setState(() {
          jumlahItem = daftar.length;
          pesan = 'Kategori: $kategoriTerpilih\nJumlah item: ${daftar.length}';
          sedangMemuat = false;
        });
      } else {
        setState(() {
          pesan = 'Server membalas dengan status ${response.statusCode}';
          sedangMemuat = false;
        });
      }
    } catch (e) {
      setState(() {
        pesan = 'Gagal terhubung: $e';
        sedangMemuat = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 1 - Masalah 2: Kategori API'),
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
            // Dropdown untuk pilih kategori
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButton<String>(
                  value: kategoriTerpilih,
                  isExpanded: true,
                  items: daftarKategori.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        kategoriTerpilih = newValue;
                      });
                      ambilData();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Hasil
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: sedangMemuat
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Jumlah Resep',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$jumlahItem',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                pesan,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: ambilData,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Ambil Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
