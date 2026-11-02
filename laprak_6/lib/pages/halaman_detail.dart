import 'package:flutter/material.dart';

import '../models/menu_item.dart';

class HalamanDetail extends StatefulWidget {
  const HalamanDetail({super.key, required this.menu});
  final MenuItem menu;

  @override
  State<HalamanDetail> createState() => _HalamanDetailState();
}

class _HalamanDetailState extends State<HalamanDetail> {
  int _selectedLevel = 1;
  int _jumlah = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menu.nama),
        backgroundColor: warnaTema,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: widget.menu.nama,
              child: CircleAvatar(
                radius: 56,
                backgroundColor: warnaTema.shade50,
                child: Icon(widget.menu.ikon, size: 56, color: warnaTema),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.menu.nama,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              formatRupiah(widget.menu.harga),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: warnaTema,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Pilihan Level Pedas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                final level = index + 1;
                return ChoiceChip(
                  label: Text('Level $level'),
                  selected: _selectedLevel == level,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedLevel = level);
                    }
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _jumlah > 1
                      ? () => setState(() => _jumlah--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$_jumlah',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _jumlah++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${formatRupiah(widget.menu.harga * _jumlah)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: warnaTema,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.menu.deskripsi, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
