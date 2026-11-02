import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/menu_item.dart';

/// SELECT * FROM menu ORDER BY nama ASC/DESC
Future<List<MenuItem>> ambilDaftarMenu({bool urutMenurun = false}) async {
  final data = await Supabase.instance.client
      .from('menu')
      .select()
      .order('nama', ascending: !urutMenurun);

  return data.map((baris) => MenuItem.fromJson(baris)).toList();
}

/// INSERT INTO menu (...) VALUES (...)
Future<void> tambahMenu({
  required String nama,
  required String kategori,
  required int harga,
  required String deskripsi,
}) async {
  await Supabase.instance.client.from('menu').insert({
    'nama': nama,
    'kategori': kategori,
    'harga': harga,
    'deskripsi': deskripsi,
    // 'id' tidak diisi: PostgreSQL membuatnya otomatis.
    // 'tersedia' dan 'dibuat_pada' memakai nilai default tabel.
  });
}
