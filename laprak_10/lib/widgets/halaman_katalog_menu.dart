import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../services/menu_service.dart';
import '../utils/formatter.dart';
import 'banner_catatan.dart';
import 'form_tambah_menu.dart';

class HalamanKatalogMenu extends StatefulWidget {
  const HalamanKatalogMenu({
    super.key,
    required this.judul,
    this.catatan,
    this.catatanForm,
    this.tampilkanSimulasiError = false,
  });

  final String judul;
  final String? catatan;
  final String? catatanForm;
  final bool tampilkanSimulasiError;

  @override
  State<HalamanKatalogMenu> createState() => _HalamanKatalogMenuState();
}

class _HalamanKatalogMenuState extends State<HalamanKatalogMenu> {
  late Future<List<MenuItem>> _futureMenu;
  bool _sedangMemuat = false;

  @override
  void initState() {
    super.initState();
    _futureMenu = ambilDaftarMenu();
  }

  Future<bool> _muatUlang({bool tampilkanPesan = true}) async {
    if (_sedangMemuat) return false;

    final future = ambilDaftarMenu();
    setState(() {
      _sedangMemuat = true;
      _futureMenu = future;
    });

    try {
      await future;
      if (!mounted) return false;

      if (tampilkanPesan) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data menu dimuat ulang'),
            duration: Duration(seconds: 1),
          ),
        );
      }
      return true;
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      return false;
    } finally {
      if (mounted) {
        setState(() => _sedangMemuat = false);
      }
    }
  }

  Future<void> _bukaFormTambah() async {
    final berhasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormTambahMenu(
          judul: 'Tambah Menu',
          catatan: widget.catatanForm,
          tampilkanSimulasiError: widget.tampilkanSimulasiError,
        ),
      ),
    );

    if (berhasil != true) return;

    final berhasilMuat = await _muatUlang(tampilkanPesan: false);
    if (!mounted || !berhasilMuat) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Menu berhasil ditambahkan')));
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
            onPressed: _sedangMemuat
                ? null
                : () {
                    _muatUlang();
                  },
            icon: _sedangMemuat
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
            tooltip: _sedangMemuat ? 'Memuat...' : 'Muat ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.catatan != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: BannerCatatan(teks: widget.catatan!),
            ),
          Expanded(
            child: FutureBuilder<List<MenuItem>>(
              future: _futureMenu,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _tampilanError('${snapshot.error}', () async {
                    await _muatUlang();
                  });
                }

                final daftar = snapshot.data ?? const <MenuItem>[];
                if (daftar.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await _muatUlang();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 160),
                        Icon(Icons.inbox, size: 56, color: Colors.grey),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Belum ada data menu di tabel. Tambahkan data dulu.',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _muatUlang();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormTambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Menu'),
      ),
    );
  }

  Widget _kartuMenu(MenuItem menu) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.nama,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: menu.tersedia ? null : Colors.grey,
                        ),
                      ),
                      Text(
                        '${menu.kategori} - ${menu.tersedia ? 'Tersedia' : 'Tidak tersedia'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatRupiah(menu.harga),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            if (menu.deskripsi.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(menu.deskripsi),
            ],
            const SizedBox(height: 8),
            Text(
              'Dibuat: ${formatTanggal(menu.dibuatPada)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _tampilanError(String pesan, Future<void> Function() onCobaLagi) {
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
