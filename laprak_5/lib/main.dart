import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// Model data menu. Satu objek menyimpan 4 informasi sekaligus.
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

/// Helper kecil: mengubah 25000 menjadi "Rp 25.000". Boleh disalin apa adanya.
String formatRupiah(int nilai) {
  final pola = RegExp(r'\B(?=(\d{3})+(?!\d))');
  final hasil = nilai.toString().replaceAllMapped(pola, (match) => '.');
  return 'Rp $hasil';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final List<MenuItem> daftarMenu = const [
    MenuItem(
      nama: 'Mie Aceh',
      deskripsi: 'Mie tebal dengan kuah bumbu rempah khas Aceh',
      harga: 25000,
      ikon: Icons.ramen_dining,
    ),
    MenuItem(
      nama: 'Kopi Sanger',
      deskripsi: 'Kopi robusta diseduh dengan susu kental manis',
      harga: 15000,
      ikon: Icons.local_cafe,
    ),
    MenuItem(
      nama: 'Ayam Tangkap',
      deskripsi: 'Ayam goreng dengan daun kari dan daun pandan',
      harga: 35000,
      ikon: Icons.lunch_dining,
    ),
    MenuItem(
      nama: 'Pisang Goreng Keju',
      deskripsi: 'Pisang goreng renyah dengan topping keju parut',
      harga: 12000,
      ikon: Icons.bakery_dining,
    ),
    MenuItem(
      nama: 'Es Timun Serut',
      deskripsi: 'Minuman segar dari timun serut dan jeruk nipis',
      harga: 10000,
      ikon: Icons.local_drink,
    ),
    MenuItem(
      nama: 'Sate Matang',
      deskripsi: 'Sate daging sapi khas Aceh dengan kuah kaldu gurih',
      harga: 30000,
      ikon: Icons.kebab_dining,
    ),
    MenuItem(
      nama: 'Roti Canai',
      deskripsi: 'Roti pipih khas India/Aceh disajikan dengan gulai',
      harga: 15000,
      ikon: Icons.flatware,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Latihan 2 - Daftar Menu'),
          backgroundColor: Colors.teal,
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
                  backgroundColor: Colors.teal.shade50,
                  child: Icon(menu.ikon, color: Colors.teal),
                ),
                title: Text(
                  menu.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  formatRupiah(menu.harga),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Anda memilih ${menu.nama}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
