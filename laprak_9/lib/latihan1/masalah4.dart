import 'package:flutter/material.dart';

import '../widgets/halaman_daftar_menu.dart';

/// Tugas 4: menambahkan kolom dibuat_pada ke model dan menampilkannya.
class HalamanMasalah4 extends StatelessWidget {
  const HalamanMasalah4({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanDaftarMenu(
      judul: 'Tugas 4: Kolom dibuat_pada',
      catatan:
          'Kolom timestamptz dibuat_pada dipetakan menjadi DateTime? pada model '
          'dan ditampilkan di bawah deskripsi menu.',
      tampilkanDibuatPada: true,
    );
  }
}
