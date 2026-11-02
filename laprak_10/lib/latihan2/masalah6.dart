import 'package:flutter/material.dart';

import '../widgets/banner_catatan.dart';

class HalamanInsert6 extends StatefulWidget {
  const HalamanInsert6({super.key});

  @override
  State<HalamanInsert6> createState() => _HalamanInsert6State();
}

class _HalamanInsert6State extends State<HalamanInsert6> {
  bool? _nilaiKembali;
  bool _sudahKembali = false;

  Future<void> _bukaHalamanKeputusan() async {
    final hasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const HalamanKeputusan()),
    );

    if (!mounted) return;
    setState(() {
      _nilaiKembali = hasil;
      _sudahKembali = true;
    });

    final pesan = hasil == null
        ? 'Halaman ditutup tanpa nilai kembali'
        : 'Nilai diterima: $hasil';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas 6: Navigator.push<bool>'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const BannerCatatan(
            teks:
                'Halaman ini membuktikan bahwa Navigator.push dapat menerima '
                'nilai kembali. Nilai true berarti data berhasil disimpan, '
                'sedangkan false atau null berarti form dibatalkan.',
          ),
          const SizedBox(height: 20),
          const Text(
            'Alur pengujian',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tekan tombol di bawah, pilih Simpan atau Batal pada halaman '
            'berikutnya, lalu perhatikan nilai yang diterima halaman ini.',
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _bukaHalamanKeputusan,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Buka Halaman Keputusan'),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nilai yang diterima',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _sudahKembali
                        ? '${_nilaiKembali ?? 'null'} (${_nilaiKembali.runtimeType})'
                        : 'Belum ada nilai dikembalikan.',
                    style: const TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HalamanKeputusan extends StatelessWidget {
  const HalamanKeputusan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Keputusan'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BannerCatatan(
              teks:
                  'Pilih salah satu tombol. Nilai boolean akan dikirim kembali '
                  'ke halaman sebelumnya melalui Navigator.pop.',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.check),
              label: const Text('Simpan (return true)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context, false),
              icon: const Icon(Icons.close),
              label: const Text('Batal (return false)'),
            ),
          ],
        ),
      ),
    );
  }
}
