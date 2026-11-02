import 'package:flutter/material.dart';

import '../widgets/halaman_daftar_menu.dart';

/// Tugas 3: menambah baris dari Table Editor tanpa mengubah kode aplikasi.
class HalamanMasalah3 extends StatelessWidget {
  const HalamanMasalah3({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanDaftarMenu(
      judul: 'Tugas 3: Baris Baru dari Dashboard',
      catatan:
          'Tambahkan satu baris baru langsung dari Table Editor, lalu tekan '
          'refresh. Baris tersebut akan muncul di aplikasi ini.',
    );
  }
}
