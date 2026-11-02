import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Kategori {
  final String nama;
  final IconData ikon;
  final Color warna;

  const Kategori(this.nama, this.ikon, this.warna);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final List<Kategori> daftarKategori = const [
    Kategori('Makanan', Icons.restaurant, Colors.orange),
    Kategori('Minuman', Icons.local_drink, Colors.teal),
    Kategori('Kue & Roti', Icons.cake, Colors.pink),
    Kategori('Kopi', Icons.coffee, Colors.brown),
    Kategori('Jajanan', Icons.bakery_dining, Colors.indigo),
    Kategori('Buah', Icons.eco, Colors.green),
  ];

  Widget kartuKategori(BuildContext context, Kategori kategori) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kategori dipilih: ${kategori.nama}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: kategori.warna.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kategori.warna.withValues(alpha: 0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(kategori.ikon, size: 40, color: kategori.warna),
            const SizedBox(height: 10),
            Text(
              kategori.nama,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kategori.warna,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Latihan 3 - Kategori'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: daftarKategori
              .map((kategori) => kartuKategori(context, kategori))
              .toList(),
        ),
      ),
    );
  }
}
