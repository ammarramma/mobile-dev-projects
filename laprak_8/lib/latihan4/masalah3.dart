// Latihan 4 - Masalah 3: Analisis Parameter: Passing ID vs Passing Full Object
// Standalone widget: Analisis mendalam perbandingan strategi navigasi data antar halaman

import 'package:flutter/material.dart';

class HalamanAnalisisPassingId extends StatelessWidget {
  const HalamanAnalisisPassingId({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 4 - Masalah 3: Analisis Passing ID'),
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
            // Header Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.teal.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.compare, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          'Pertanyaan Analisis Modul:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bandingkan cara Latihan 4 (mengirim idMeal saja) dengan cara Pertemuan 3 (mengirim seluruh objek Meal). '
                      'Sebutkan kelebihan dan kekurangan masing-masing!',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card Pendekatan 1: Mengirim ID saja (Latihan 4)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tag, color: Colors.indigo),
                        SizedBox(width: 8),
                        Text(
                          'Pendekatan A: Mengirim ID Saja (Latihan 4)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                      child: const Text(
                        'Navigator.push(..., HalamanDetail(idMeal: meal.id));\n// HalamanDetail melakukan fetch lookup.php?i=idMeal',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kelebihan: Data Always Fresh & Hemat Payload Awal. '
                            'Endpoint katalog tidak perlu mengunduh teks instruksi/detail yang berat. Data di halaman detail selalu versi paling aktual dari server.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kekurangan: Ada Latency/Loading Tambahan. '
                            'Pengguna harus menunggu indikator loading lagi saat membuka halaman detail karena ada HTTP request kedua.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card Pendekatan 2: Mengirim Seluruh Objek (Pertemuan 3)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.inventory_2, color: Colors.deepOrange),
                        SizedBox(width: 8),
                        Text(
                          'Pendekatan B: Mengirim Full Object (Pertemuan 3)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                      child: const Text(
                        'Navigator.push(..., HalamanDetail(meal: meal));\n// HalamanDetail langsung membaca field meal tanpa fetch',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kelebihan: Instan Tanpa Loading. '
                            'Transisi layar mulus seketika karena semua data sudah tersedia di memori tanpa perlu jaringan internet aktif lagi.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kekurangan: Beban Awal Tinggi & Data Berpotensi Basi (Stale). '
                            'Tidak cocok jika API daftar (katalog) sengaja memotong field (seperti filter.php yang tidak menyertakan strInstructions).',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Kesimpulan Praktis
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                '📌 Rekomendasi Industri:\n'
                'Gunakan pendekatan Latihan 4 (Passing ID) saat arsitektur REST API memisahkan endpoint Summary (/filter) dengan Detail (/lookup), '
                'atau saat data detail memiliki ukuran besar (seperti artikel blog, resep panjang, spesifikasi teknis).',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
