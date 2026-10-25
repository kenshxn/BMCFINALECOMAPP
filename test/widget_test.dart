import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_shop/screens/product_list_screen.dart';

void main() {
  testWidgets('Store preview displays catalog, search, and categories', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProductListScreen(demoMode: true)),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('sari sari'), findsOneWidget);
    expect(find.text('Your neighborhood\nstore, delivered.'), findsOneWidget);
    expect(find.text('Lucky Me! Pancit Canton'), findsOneWidget);
    expect(find.text('Snacks'), findsWidgets);
    await tester.enterText(find.byType(TextField), 'milk');
    await tester.pumpAndSettle();
    expect(find.text('Fresh milk 1 L'), findsOneWidget);
    expect(find.text('Lucky Me! Pancit Canton'), findsNothing);
  });
}
