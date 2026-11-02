import 'package:flutter/material.dart';

import '../widgets/halaman_daftar_menu.dart';

/// Tugas 1: membuktikan data berasal dari tabel menu di Supabase.
class HalamanMasalah1 extends StatelessWidget {
  const HalamanMasalah1({super.key});

  @override
  Widget build(BuildContext context) {
    return const HalamanDaftarMenu(
      judul: 'Tugas 1: SELECT Pertama',
      catatan:
          'Data pada daftar ini dibaca langsung dari tabel menu di Supabase. '
          'Bandingkan isinya dengan Table Editor.',
    );
  }
}
