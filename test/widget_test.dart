import 'package:flutter_test/flutter_test.dart';
import 'package:hajato/main.dart';

void main() {
  testWidgets('HAJATO App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HajatoApp());
    expect(find.byType(HajatoApp), findsOneWidget);
  });
}
