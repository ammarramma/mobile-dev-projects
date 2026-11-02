import 'package:flutter/material.dart';

import '../widgets/halaman_katalog_menu.dart';

class HalamanInsert1 extends StatelessWidget {
  const HalamanInsert1({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanKatalogMenu(
      judul: 'Tugas 1: Menu Baru dari Aplikasi',
      catatan:
          'Tambahkan satu menu baru melalui tombol Tambah Menu, lalu periksa '
          'baris tersebut di Table Editor Supabase.',
      catatanForm:
          'Isi seluruh field lalu tekan Simpan. Nilai true dikembalikan ke '
          'katalog setelah INSERT berhasil.',
    );
  }
}
