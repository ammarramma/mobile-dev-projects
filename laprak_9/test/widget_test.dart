import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:laprak_9/main.dart';

void main() {
  testWidgets('Router menampilkan daftar tugas Latihan 1', (tester) async {
    await tester.pumpWidget(const PraktikumRouter());

    expect(find.text('Praktikum Pertemuan 5'), findsOneWidget);
    expect(find.text('Tugas 1: SELECT Pertama'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('Tugas 6: Dua Perangkat'), findsOneWidget);
  });
}
