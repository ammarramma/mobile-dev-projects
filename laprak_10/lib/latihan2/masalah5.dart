import 'package:flutter/material.dart';

import '../widgets/halaman_katalog_menu.dart';

class HalamanInsert5 extends StatelessWidget {
  const HalamanInsert5({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanKatalogMenu(
      judul: 'Tugas 5: Validasi Deskripsi',
      catatan:
          'Isi deskripsi lebih dari 100 karakter. Validator menolak input '
          'sebelum data dikirim ke Supabase.',
      catatanForm:
          'Tempel teks lebih dari 100 karakter. Penghitung dan pesan error '
          'akan muncul di bawah kolom deskripsi.',
    );
  }
}
