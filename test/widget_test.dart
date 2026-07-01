import 'package:flutter_test/flutter_test.dart';
import 'package:hajato/main.dart';
import 'package:hajato/app/routes/app_routes.dart'; // Tambahkan import ini supaya bisa pakai AppRoutes

void main() {
  testWidgets('HAJATO App smoke test', (WidgetTester tester) async {
    // Tambahkan initialRoute di sini
    await tester.pumpWidget(const HajatoApp(initialRoute: AppRoutes.onboarding));
    
    expect(find.byType(HajatoApp), findsOneWidget);
  });
}