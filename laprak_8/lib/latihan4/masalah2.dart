// Latihan 4 - Masalah 2: Validasi ID Resep & Respons Null API
// Standalone widget: Menguji perilaku API saat ID tidak ditemukan (i=9999999) dan pentingnya validasi null

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanValidasiNullDetail extends StatefulWidget {
  const HalamanValidasiNullDetail({super.key});

  @override
  State<HalamanValidasiNullDetail> createState() => _HalamanValidasiNullDetailState();
}

class _HalamanValidasiNullDetailState extends State<HalamanValidasiNullDetail> {
  String idInput = '9999999';
  bool gunakanValidasiNull = true;
  String logHasil = '';
  bool sedangLoading = false;

  Future<void> _ujiAmbilDetail() async {
    setState(() {
      sedangLoading = true;
      logHasil = 'Mengirim request: lookup.php?i=$idInput...\n';
    });

    try {
      final response = await http
          .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idInput'))
          .timeout(const Duration(seconds: 10));

      logHasil += 'Status Code: ${response.statusCode}\n';
      logHasil += 'Body mentah: ${response.body}\n\n';

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (gunakanValidasiNull) {
        logHasil += '[MODE DENGAN VALIDASI]\n';
        final daftar = data['meals'] as List<dynamic>?;
        if (daftar == null || daftar.isEmpty) {
          throw Exception('Detail resep tidak ditemukan (server membalas {"meals": null})');
        }
        logHasil += 'SUKSES: Resep ditemukan: ${daftar.first['strMeal']}\n';
      } else {
        logHasil += '[MODE TANPA VALIDASI (SIMULASI CRASH)]\n';
        // Sengaja memaksa cast langsung tanpa cek null
        final daftar = data['meals'] as List<dynamic>;
        logHasil += 'SUKSES: Resep ditemukan: ${daftar.first['strMeal']}\n';
      }
    } catch (e) {
      logHasil += '❌ ERROR TERTANGKAP:\n$e\n';
    } finally {
      if (mounted) {
        setState(() {
          sedangLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 4 - Masalah 2: Validasi Null ID'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Menu Utama',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Penjelasan Kasus Tugas 2
            Card(
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tugas Mahasiswa Nomor 2:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Ketika endpoint lookup.php diberi ID yang tidak ada (mis. 9999999), TheMealDB membalas JSON {"meals": null}. '
                      'Jika kode langsung memanggil data["meals"] as List atau .first tanpa pengecekan null, aplikasi akan crash seketika.',
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Form Kontrol
            TextFormField(
              initialValue: idInput,
              decoration: const InputDecoration(
                labelText: 'ID Resep (TheMealDB)',
                border: OutlineInputBorder(),
                helperText: 'Coba "52772" (valid) atau "9999999" (fiktif/null)',
              ),
              onChanged: (val) => idInput = val,
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gunakan pengecekan null (if daftar == null):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Switch(
                  value: gunakanValidasiNull,
                  activeThumbColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      gunakanValidasiNull = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: sedangLoading ? null : _ujiAmbilDetail,
              icon: sedangLoading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send),
              label: Text(sedangLoading ? 'Memproses...' : 'Uji Panggilan API'),
              style: ElevatedButton.styleFrom(
                backgroundColor: gunakanValidasiNull ? Colors.teal : Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Terminal Log Output:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              height: 250,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  logHasil.isEmpty ? 'Tekan tombol "Uji Panggilan API" untuk melihat respon...' : logHasil,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.lightGreenAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
