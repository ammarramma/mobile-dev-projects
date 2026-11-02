import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import 'halaman_detail.dart';

class HalamanKatalog extends StatelessWidget {
  const HalamanKatalog({super.key});

  final List<MenuItem> daftarMenu = const [
    MenuItem(
      nama: 'Mie Aceh',
      deskripsi: 'Mie tebal dengan kuah bumbu rempah khas Aceh, disajikan dengan acar bawang dan emping.',
      harga: 25000,
      ikon: Icons.ramen_dining,
    ),
    MenuItem(
      nama: 'Kopi Sanger',
      deskripsi: 'Kopi robusta Gayo diseduh dengan susu kental manis, disajikan panas dalam gelas kaca.',
      harga: 15000,
      ikon: Icons.local_cafe,
    ),
    MenuItem(
      nama: 'Ayam Tangkap',
      deskripsi: 'Ayam goreng khas Aceh yang ditaburi daun kari dan daun pandan goreng.',
      harga: 35000,
      ikon: Icons.lunch_dining,
    ),
    MenuItem(
      nama: 'Pisang Goreng Keju',
      deskripsi: 'Pisang goreng renyah dengan topping keju parut dan susu kental manis.',
      harga: 12000,
      ikon: Icons.bakery_dining,
    ),
    MenuItem(
      nama: 'Es Timun Serut',
      deskripsi: 'Minuman segar dari timun serut, jeruk nipis, dan sirup gula.',
      harga: 10000,
      ikon: Icons.local_drink,
    ),
    MenuItem(
      nama: 'Timphan',
      deskripsi: 'Kue tradisional Aceh dari tepung ketan berisi serikaya, dibungkus daun pisang.',
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
              leading: Hero(
                tag: menu.nama,
                child: CircleAvatar(
                  backgroundColor: warnaTema.shade50,
                  child: Icon(menu.ikon, color: warnaTema),
                ),
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
