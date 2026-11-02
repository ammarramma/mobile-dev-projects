import 'package:flutter/material.dart';

import '../widgets/halaman_daftar_menu.dart';

/// Tugas 6: membandingkan data pada dua perangkat yang terhubung.
class HalamanMasalah6 extends StatelessWidget {
  const HalamanMasalah6({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanDaftarMenu(
      judul: 'Tugas 6: Dua Perangkat',
      catatan:
          'Jalankan aplikasi di dua perangkat sekaligus. Keduanya membaca tabel '
          'yang sama, sehingga isi daftar akan identik setelah refresh.',
    );
  }
}
