// Latihan 1 - Masalah 5: Penanganan Koneksi Terputus
// Standalone widget

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanOfflineDemo extends StatefulWidget {
  const HalamanOfflineDemo({super.key});

  @override
  State<HalamanOfflineDemo> createState() => _HalamanOfflineDemoState();
}

class _HalamanOfflineDemoState extends State<HalamanOfflineDemo> {
  bool sedangMemuat = false;
  String pesan = '';

  Future<void> ambilData() async {
    setState(() => {sedangMemuat = true, pesan = ''});
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood',
            ),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final daftar = (data['meals'] as List<dynamic>?) ?? const [];
        setState(
          () => {
            pesan = 'SUKSES: Status 200, ${daftar.length} item',
            sedangMemuat = false,
          },
        );
      } else {
        setState(
          () => {
            pesan = 'Status: ${response.statusCode}',
            sedangMemuat = false,
          },
        );
      }
    } on SocketException catch (e) {
      setState(
        () => {
          pesan = 'SocketException: ${e.message}\nPerangkat offline!',
          sedangMemuat = false,
        },
      );
    } catch (e) {
      setState(() => {pesan = 'Error: $e', sedangMemuat = false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 1 - Masalah 5: Offline'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Coba matikan koneksi internet untuk simulasi offline',
              style: TextStyle(fontSize: 14, color: Colors.orange),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: ambilData,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Ambil Data'),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Hasil:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: sedangMemuat
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: Text(
                            pesan.isEmpty ? 'Tekan tombol' : pesan,
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
            ),
            const Text(
              'Offline -> SocketException -> masuk ke blok catch',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
