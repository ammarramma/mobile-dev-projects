String formatRupiah(int nilai) {
  final pola = RegExp(r'\B(?=(\d{3})+(?!\d))');
  final hasil = nilai.toString().replaceAllMapped(pola, (match) => '.');
  return 'Rp $hasil';
}

String formatTanggal(DateTime? waktu) {
  if (waktu == null) return '-';

  final lokal = waktu.toLocal();
  String duaDigit(int angka) => angka.toString().padLeft(2, '0');

  return '${duaDigit(lokal.day)}/${duaDigit(lokal.month)}/${lokal.year} '
      '${duaDigit(lokal.hour)}:${duaDigit(lokal.minute)}';
}
