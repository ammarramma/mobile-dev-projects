import 'package:flutter/material.dart';

import '../widgets/halaman_katalog_menu.dart';

class HalamanInsert3 extends StatelessWidget {
  const HalamanInsert3({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanKatalogMenu(
      judul: 'Tugas 3: Validasi Harga Teks',
      catatan:
          'Isi harga dengan teks seperti dua ribu. Validator menghentikan '
          'proses sebelum request INSERT dikirim ke Supabase.',
      catatanForm:
          'Coba isi harga "dua ribu" lalu tekan Simpan. Pesan "Harga harus '
          'berupa angka" akan muncul.',
    );
  }
}
