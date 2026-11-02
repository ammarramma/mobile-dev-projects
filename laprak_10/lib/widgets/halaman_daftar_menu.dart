import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../services/menu_service.dart';
import '../utils/formatter.dart';

/// Halaman daftar menu yang dipakai ulang oleh seluruh tugas Latihan 1.
class HalamanDaftarMenu extends StatefulWidget {
  const HalamanDaftarMenu({
    super.key,
    required this.judul,
    this.catatan,
    this.urutMenurun = false,
    this.tampilkanDibuatPada = false,
  });

  final String judul;
  final String? catatan;
  final bool urutMenurun;
  final bool tampilkanDibuatPada;

  @override
  State<HalamanDaftarMenu> createState() => _HalamanDaftarMenuState();
}

class _HalamanDaftarMenuState extends State<HalamanDaftarMenu> {
  late Future<List<MenuItem>> _futureMenu;

  @override
  void initState() {
    super.initState();
    _futureMenu = _ambilData();
  }

  Future<List<MenuItem>> _ambilData() {
    return ambilDaftarMenu(urutMenurun: widget.urutMenurun);
  }

  void _muatUlang() {
    setState(() {
      _futureMenu = _ambilData();
    });
  }

  Future<void> _tarikUntukMuatUlang() async {
    final future = _ambilData();
    setState(() {
      _futureMenu = future;
    });

    try {
      await future;
    } catch (_) {
      // Error sudah ditangani oleh FutureBuilder.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.judul),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _muatUlang,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.catatan != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: _BannerCatatan(teks: widget.catatan!),
            ),
          Expanded(
            child: FutureBuilder<List<MenuItem>>(
              future: _futureMenu,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _tampilanError('${snapshot.error}', _muatUlang);
                }

                final daftar = snapshot.data ?? const <MenuItem>[];

                if (daftar.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _tarikUntukMuatUlang,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 160),
                        Icon(Icons.inbox, size: 56, color: Colors.grey),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Tabel masih kosong. Tambahkan data dulu.',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _tarikUntukMuatUlang,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: daftar.length,
                    itemBuilder: (context, index) {
                      return _kartuMenu(daftar[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuMenu(MenuItem menu) {
    final keterangan = StringBuffer()..write(menu.kategori);

    if (!menu.tersedia) {
      keterangan.write(' - TIDAK TERSEDIA');
    }

    if (menu.deskripsi.isNotEmpty) {
      keterangan.write('\n${menu.deskripsi}');
    }

    if (widget.tampilkanDibuatPada) {
      keterangan.write('\nDibuat: ${formatTanggal(menu.dibuatPada)}');
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: menu.tersedia
              ? Colors.teal.shade50
              : Colors.grey.shade200,
          child: Text(
            '${menu.id}',
            style: TextStyle(
              color: menu.tersedia ? Colors.teal : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          menu.nama,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: menu.tersedia ? null : Colors.grey,
          ),
        ),
        subtitle: Text(
          keterangan.toString(),
          maxLines: widget.tampilkanDibuatPada ? 4 : 3,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        trailing: Text(
          formatRupiah(menu.harga),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}

class _BannerCatatan extends StatelessWidget {
  const _BannerCatatan({required this.teks});

  final String teks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: Colors.teal.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              teks,
              style: TextStyle(fontSize: 13, color: Colors.teal.shade900),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _tampilanError(String pesan, VoidCallback onCobaLagi) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat data',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            pesan,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onCobaLagi,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    ),
  );
}
