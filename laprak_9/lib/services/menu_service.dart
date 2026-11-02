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
