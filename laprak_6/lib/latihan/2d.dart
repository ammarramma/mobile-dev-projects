import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MenuItem {
  final String nama;
  final String deskripsi;
  final int harga;
  final IconData ikon;

  const MenuItem({
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.ikon,
  });
}

String formatRupiah(int nilai) {
  final pola = RegExp(r'\B(?=(\d{3})+(?!\d))');
  final hasil = nilai.toString().replaceAllMapped(pola, (match) => '.');
  return 'Rp $hasil';
}

const MaterialColor warnaTema = Colors.teal;

// ---------------- HALAMAN 1: KATALOG ----------------
class HalamanKatalog extends StatelessWidget {
  const HalamanKatalog({super.key});

  final List<MenuItem> daftarMenu = const [
    MenuItem(
      nama: 'Mie Aceh',
      deskripsi:
          'Mie tebal dengan kuah bumbu rempah khas Aceh, disajikan dengan '
          'acar bawang dan emping. Tersedia pilihan goreng maupun kuah.',
      harga: 25000,
      ikon: Icons.ramen_dining,
    ),
    MenuItem(
      nama: 'Kopi Sanger',
      deskripsi:
          'Kopi robusta Gayo diseduh dengan susu kental manis, disajikan '
          'panas dalam gelas kaca. Menu wajib bagi penikmat kopi Aceh.',
      harga: 15000,
      ikon: Icons.local_cafe,
    ),
    MenuItem(
      nama: 'Ayam Tangkap',
      deskripsi:
          'Ayam goreng khas Aceh yang ditaburi daun kari dan daun pandan '
          'goreng. Aromanya kuat dan gurih.',
      harga: 35000,
      ikon: Icons.lunch_dining,
    ),
    MenuItem(
      nama: 'Pisang Goreng Keju',
      deskripsi:
          'Pisang goreng renyah dengan topping keju parut dan susu kental '
          'manis. Cocok sebagai camilan sore.',
      harga: 12000,
      ikon: Icons.bakery_dining,
    ),
    MenuItem(
      nama: 'Es Timun Serut',
      deskripsi:
          'Minuman segar dari timun serut, jeruk nipis, dan sirup gula. '
          'Pelepas dahaga paling pas di siang hari.',
      harga: 10000,
      ikon: Icons.local_drink,
    ),
    MenuItem(
      nama: 'Timphan',
      deskripsi:
          'Kue tradisional Aceh dari tepung ketan berisi serikaya, '
          'dibungkus daun pisang lalu dikukus.',
      harga: 8000,
      ikon: Icons.cake,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Menu'),
        backgroundColor: warnaTema,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final menu = daftarMenu[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: warnaTema.shade50,
                child: Icon(menu.ikon, color: warnaTema),
              ),
              title: Text(
                menu.nama,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                menu.deskripsi,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                formatRupiah(menu.harga),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: warnaTema,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HalamanDetail(menu: menu),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ---------------- HALAMAN 2: DETAIL ----------------
class HalamanDetail extends StatelessWidget {
  const HalamanDetail({super.key, required this.menu});

  final MenuItem menu; // data yang diterima dari halaman katalog

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menu.nama),
        backgroundColor: warnaTema,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: warnaTema.shade50,
              child: Icon(menu.ikon, size: 56, color: warnaTema),
            ),
            const SizedBox(height: 24),
            Text(
              menu.nama,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              formatRupiah(menu.harga),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: warnaTema,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(menu.deskripsi, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- ENTRY POINT ----------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HalamanKatalog(),
    );
  }
}
