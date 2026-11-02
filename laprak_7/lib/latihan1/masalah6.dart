// Latihan 1 - Masalah 6: State Management - Penundaan setState
// Standalone widget

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanStateManagement extends StatefulWidget {
  const HalamanStateManagement({super.key});

  @override
  State<HalamanStateManagement> createState() => _HalamanStateManagementState();
}

class _HalamanStateManagementState extends State<HalamanStateManagement> {
  bool sedangMemuat = true;
  String pesan = '';
  String logTeknis = '';

  @override
  void initState() {
    super.initState();
    logTeknis = 'initState() -> memanggil muatData()\n';
    muatData();
  }

  Future<void> muatData() async {
    logTeknis += 'muatData() -> setState: sedangMemuat=true\n';
    setState(() => {sedangMemuat = true, pesan = ''});

    logTeknis += 'Menunggu await ambilData()...\n';
    try {
      final url =
          'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      logTeknis += 'await selesai -> setState: update pesan\n';

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final daftar = (data['meals'] as List<dynamic>?) ?? const [];
        if (!mounted) return;
        setState(
          () => {
            pesan = 'Status: ${response.statusCode}\n${daftar.length} item',
            sedangMemuat = false,
          },
        );
      } else {
        if (!mounted) return;
        setState(
          () => {pesan = 'Error: ${response.statusCode}', sedangMemuat = false},
        );
      }
    } catch (e) {
      logTeknis += 'Exception: $e\n';
      if (!mounted) return;
      setState(() => {pesan = 'Error: $e', sedangMemuat = false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 1 - Masalah 6: State Mgmt'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Alur Eksekusi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Text(
                      logTeknis,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: sedangMemuat
                    ? const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Memuat...'),
                        ],
                      )
                    : Text(pesan),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: muatData,
              icon: const Icon(Icons.refresh),
              label: const Text('Muat Ulang'),
            ),
            const SizedBox(height: 8),
            const Text(
              'await menunggu data -> setState update UI dengan data lengkap',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
