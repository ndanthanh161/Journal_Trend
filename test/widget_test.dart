import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_trend_analyzer/main.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the search input is present.
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the default suggestions are visible.
    expect(find.text('Research Query'), findsOneWidget);
    expect(find.text('Artificial Intelligence'), findsOneWidget);

    // Verify that the empty state instruction is visible.
    expect(find.text('Explore Research'), findsOneWidget);
  });
}
