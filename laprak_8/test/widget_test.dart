import 'package:flutter_test/flutter_test.dart';
import 'package:laprak_8/main.dart';

void main() {
  testWidgets('Praktikum router smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PraktikumRouter());
    expect(find.text('Praktikum Pertemuan 4'), findsOneWidget);
  });
}
