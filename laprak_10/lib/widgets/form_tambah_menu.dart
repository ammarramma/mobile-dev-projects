import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/menu_service.dart';
import 'banner_catatan.dart';

class FormTambahMenu extends StatefulWidget {
  const FormTambahMenu({
    super.key,
    this.judul = 'Tambah Menu',
    this.catatan,
    this.tampilkanSimulasiError = false,
  });

  final String judul;
  final String? catatan;
  final bool tampilkanSimulasiError;

  @override
  State<FormTambahMenu> createState() => _FormTambahMenuState();
}

class _FormTambahMenuState extends State<FormTambahMenu> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _harga = TextEditingController();
  final _deskripsi = TextEditingController();

  String _kategori = 'Makanan';
  bool _sedangMenyimpan = false;
  bool _simulasiError = false;

  @override
  void dispose() {
    _nama.dispose();
    _harga.dispose();
    _deskripsi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sedangMenyimpan = true);

    try {
      if (_simulasiError) {
        throw Exception('Koneksi internet terputus (simulasi)');
      }

      await tambahMenu(
        nama: _nama.text.trim(),
        kategori: _kategori,
        harga: int.parse(_harga.text.trim()),
        deskripsi: _deskripsi.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } on PostgrestException catch (e) {
      if (!mounted) return;
      setState(() => _sedangMenyimpan = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: ${e.message}')));
    } catch (e) {
      if (!mounted) return;
      setState(() => _sedangMenyimpan = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.judul),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.catatan != null) ...[
              BannerCatatan(teks: widget.catatan!),
              const SizedBox(height: 20),
            ],
            TextFormField(
              controller: _nama,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nama menu',
                hintText: 'Contoh: Rendang Padang',
                border: OutlineInputBorder(),
              ),
              validator: (nilai) {
                if (nilai == null || nilai.trim().isEmpty) {
                  return 'Nama menu wajib diisi';
                }
                if (nilai.trim().length < 3) {
                  return 'Nama menu minimal 3 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Makanan', child: Text('Makanan')),
                DropdownMenuItem(value: 'Minuman', child: Text('Minuman')),
                DropdownMenuItem(value: 'Camilan', child: Text('Camilan')),
              ],
              onChanged: (nilai) {
                if (nilai == null) return;
                setState(() => _kategori = nilai);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _harga,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Harga (angka saja)',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              validator: (nilai) {
                if (nilai == null || nilai.trim().isEmpty) {
                  return 'Harga wajib diisi';
                }
                final angka = int.tryParse(nilai.trim());
                if (angka == null) {
                  return 'Harga harus berupa angka';
                }
                if (angka <= 0) {
                  return 'Harga harus lebih dari 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _deskripsi,
              maxLines: 3,
              maxLength: 100,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (opsional)',
                hintText: 'Deskripsi singkat, maksimal 100 karakter',
                border: OutlineInputBorder(),
              ),
              validator: (nilai) {
                if (nilai != null && nilai.length > 100) {
                  return 'Deskripsi maksimal 100 karakter';
                }
                return null;
              },
            ),
            if (widget.tampilkanSimulasiError) ...[
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _simulasiError,
                onChanged: (nilai) {
                  setState(() => _simulasiError = nilai);
                },
                title: const Text('Simulasikan koneksi gagal'),
                subtitle: const Text(
                  'Aktifkan untuk menguji blok try/catch tanpa mematikan internet.',
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _sedangMenyimpan ? null : _simpan,
              icon: _sedangMenyimpan
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(_sedangMenyimpan ? 'Menyimpan...' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
