import 'package:flutter/material.dart';

import '../widgets/halaman_katalog_menu.dart';

class HalamanInsert4 extends StatelessWidget {
  const HalamanInsert4({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanKatalogMenu(
      judul: 'Tugas 4: Penanganan Error INSERT',
      catatan:
          'Aktifkan simulasi koneksi gagal di form untuk melihat blok '
          'try/catch bekerja. Aplikasi tetap berjalan dan menampilkan error.',
      catatanForm: 'Aktifkan "Simulasikan koneksi gagal", lalu tekan Simpan.',
      tampilkanSimulasiError: true,
    );
  }
}
