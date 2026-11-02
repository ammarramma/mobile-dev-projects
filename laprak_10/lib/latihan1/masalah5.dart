import 'package:flutter/material.dart';

import '../widgets/halaman_daftar_menu.dart';

/// Tugas 5: mengubah pengurutan dari ASC menjadi DESC.
class HalamanMasalah5 extends StatelessWidget {
  const HalamanMasalah5({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanDaftarMenu(
      judul: 'Tugas 5: Urutan Z-A',
      catatan:
          'Daftar diurutkan menurun (Z-A) melalui '
          ".order('nama', ascending: false).",
      urutMenurun: true,
    );
  }
}
