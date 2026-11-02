// Latihan 1 - Masalah 4: Kegunaan await
// Standalone widget

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanAwaitDemo extends StatefulWidget {
  const HalamanAwaitDemo({super.key});

  @override
  State<HalamanAwaitDemo> createState() => _HalamanAwaitDemoState();
}

class _HalamanAwaitDemoState extends State<HalamanAwaitDemo> {
  String logPesan = '';

  void _fetchWithAwait() {
    setState(() => logPesan = 'Mulai fetch WITH await...\n');
    final url = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood';
    http.get(Uri.parse(url)).then((response) {
      setState(() => logPesan += 'Status Code: ${response.statusCode}\nSUKSES: await mengekstrak Response dari Future\n');
    }).catchError((e) {
      setState(() => logPesan += 'ERROR: $e\n');
    });
  }

  void _fetchWithoutAwait() {
    setState(() => logPesan = 'Mulai fetch WITHOUT await...\n');
    final url = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood';
    final futureResponse = http.get(Uri.parse(url));
    setState(() => logPesan += 'futureResponse bertipe Future<Response>\n');
    setState(() => logPesan += 'Tidak bisa akses statusCode langsung!\n');
    setState(() => logPesan += 'Solusi: await futureResponse untuk dapetin Response\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan 1 - Masalah 4: await'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('await berfungsi untuk:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('1. Menunggu Future selesai\n2. Mengekstrak nilai dari Future<T>'),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: _fetchWithAwait, child: const Text('DENGAN await'))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: _fetchWithoutAwait, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('TANPA await'))),
            ]),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Log:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: SingleChildScrollView(child: Text(logPesan.isEmpty ? 'Tekan tombol' : logPesan, style: const TextStyle(fontFamily: 'monospace')))))),
            const Text('await menunggu Future selesai dan mengembalikan nilai T-nya', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
