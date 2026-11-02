// Latihan 1 - Masalah 3: Penanganan Error - URL Rusak vs Status Code
// Standalone widget

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanErrorHandling extends StatefulWidget {
  const HalamanErrorHandling({super.key});

  @override
  State<HalamanErrorHandling> createState() => _HalamanErrorHandlingState();
}

class _HalamanErrorHandlingState extends State<HalamanErrorHandling> {
  bool sedangMemuat = false;
  String pesan = '';
  String jenisError = '';

  final List<Map<String, String>> testCases = [
    {'nama': 'URL Valid (200 OK)', 'url': 'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'},
    {'nama': 'URL Rusak (404)', 'url': 'https://www.themealdb.com/api/json/v1/1/filterr.php?c=Seafood'},
    {'nama': 'Domain Salah', 'url': 'https://www.themealdbxx.com/api/json/v1/1/filter.php?c=Seafood'},
  ];

  Future<void> ujiUrl(String url) async {
    setState(() => {sedangMemuat = true, pesan = '', jenisError = ''});

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final daftar = (data['meals'] as List<dynamic>?) ?? const [];
        setState(() => {pesan = 'SUKSES: Status ${response.statusCode}\nJumlah: ${daftar.length}', jenisError = 'Status 200', sedangMemuat = false});
      } else {
        setState(() => {pesan = 'ERROR: Status ${response.statusCode}', jenisError = 'Status Code: ${response.statusCode}', sedangMemuat = false});
      }
    } catch (e) {
      setState(() => {pesan = 'ERROR: $e', jenisError = 'Exception (Catch)', sedangMemuat = false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 1 - Masalah 3: Error Handling'),
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
            const Text('Pilih test case:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...testCases.map((tc) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: () => ujiUrl(tc['url']!),
                    child: Text(tc['nama']!),
                  ),
                )).toList(),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Hasil:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  Text('Jenis: $jenisError', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  sedangMemuat ? const CircularProgressIndicator() : Text(pesan, style: const TextStyle(fontFamily: 'monospace')),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Error server (404) -> statusCode != 200\nURL/Domain salah -> catch block', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
