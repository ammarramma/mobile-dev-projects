import 'package:flutter/material.dart';

import '../widgets/halaman_daftar_menu.dart';

/// Tugas 2: mengubah data dari Table Editor lalu memuat ulang daftar.
class HalamanMasalah2 extends StatelessWidget {
  const HalamanMasalah2({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanDaftarMenu(
      judul: 'Tugas 2: Ubah dari Table Editor',
      catatan:
          'Ubah nama salah satu menu di Table Editor, lalu tekan tombol '
          'refresh di kanan atas. Perubahan akan muncul tanpa mengubah kode.',
    );
  }
}
