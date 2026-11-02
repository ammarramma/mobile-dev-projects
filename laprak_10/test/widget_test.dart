import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:laprak_10/main.dart';
import 'package:laprak_10/widgets/form_tambah_menu.dart';

void main() {
  testWidgets('Router menampilkan dua latihan dan enam tugas Latihan 2', (
    tester,
  ) async {
    await tester.pumpWidget(const PraktikumRouter());

    expect(find.text('Praktikum Pertemuan 5'), findsOneWidget);
    expect(find.text('Latihan 1: SELECT Pertama'), findsOneWidget);
    expect(find.text('1.1 SELECT Pertama'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('2.1 Menu Baru dari Aplikasi'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Latihan 2: Menambah Data dengan INSERT'), findsOneWidget);
    expect(find.text('2.1 Menu Baru dari Aplikasi'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('2.6 Navigator.push<bool>'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('2.6 Navigator.push<bool>'), findsOneWidget);
  });

  testWidgets('Form menolak harga yang bukan angka', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: FormTambahMenu()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ayam Uji');
    await tester.enterText(fields.at(1), 'dua ribu');

    await tester.tap(find.text('Simpan'));
    await tester.pump();

    expect(find.text('Harga harus berupa angka'), findsOneWidget);
  });

  testWidgets('Form menolak deskripsi lebih dari 100 karakter', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: FormTambahMenu()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ayam Uji');
    await tester.enterText(fields.at(1), '30000');
    await tester.enterText(fields.at(2), 'a' * 101);

    await tester.tap(find.text('Simpan'));
    await tester.pump();

    expect(find.text('Deskripsi maksimal 100 karakter'), findsOneWidget);
  });
}
