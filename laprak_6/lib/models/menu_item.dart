import 'package:flutter/material.dart';

class MenuItem {
  final String nama;
  final String deskripsi;
  final int harga;
  final IconData ikon;

  const MenuItem({
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.ikon,
  });
}

String formatRupiah(int nilai) {
  final pola = RegExp(r'\B(?=(\d{3})+(?!\d))');
  final hasil = nilai.toString().replaceAllMapped(pola, (match) => '.');
  return 'Rp $hasil';
}

const MaterialColor warnaTema = Colors.teal;
