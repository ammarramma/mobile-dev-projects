import 'package:flutter/material.dart';

import '../widgets/halaman_katalog_menu.dart';

class HalamanInsert2 extends StatelessWidget {
  const HalamanInsert2({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanKatalogMenu(
      judul: 'Tugas 2: Nilai Default Kolom Baru',
      catatan:
          'Perhatikan ID, status Tersedia, dan waktu Dibuat pada baris baru. '
          'Ketiganya diisi otomatis oleh PostgreSQL.',
      catatanForm:
          'Kolom id, tersedia, dan dibuat_pada tidak ada di form. Database '
          'mengisinya melalui identity dan nilai default tabel.',
    );
  }
}
