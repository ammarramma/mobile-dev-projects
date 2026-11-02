// Latihan 1 - Masalah 1: Verifikasi Koneksi API dan Respons JSON
// Standalone widget - gunakan di router dengan MaterialApp

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String urlDaftar = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood';

// Widget utama untuk Masalah 1
class HalamanUjiApi extends StatefulWidget {
  const HalamanUjiApi({super.key});

  @override
  State<HalamanUjiApi> createState() => _HalamanUjiApiState();
}

class _HalamanUjiApiState extends State<HalamanUjiApi> {
  bool sedangMemuat = true;
  String pesan = '';

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

    String hasil;
    try {
      final response = await http.get(Uri.parse(urlDaftar)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final daftar = (data['meals'] as List<dynamic>?) ?? const [];
        final contoh = daftar.isEmpty ? '(tidak ada data)' : '${daftar.first}';

        hasil = 'Status code : ${response.statusCode}\n'
            'Panjang body: ${response.body.length} karakter\n'
            'Jumlah item : ${daftar.length}\n'
            'Tipe data   : ${daftar.runtimeType}\n\n'
            'Isi item pertama (JSON mentah):\n\n$contoh';
      } else {
        hasil = 'Server membalas dengan status ${response.statusCode}';
      }
    } catch (e) {
      hasil = 'Gagal terhubung ke server:\n\n$e';
    }

    if (!mounted) return;
    setState(() {
      pesan = hasil;
      sedangMemuat = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 1 - Masalah 1: Verifikasi API'),
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
        child: sedangMemuat
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        pesan,
                        style: const TextStyle(fontSize: 13, height: 1.5),
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
