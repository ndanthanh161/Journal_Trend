import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:journal_trend_analyzer/state/theme_provider.dart';
import 'package:journal_trend_analyzer/widgets/theme_toggle_button.dart';

void main() {
  testWidgets('ThemeToggleButton displays correct icon and toggles theme',
      (WidgetTester tester) async {
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>.value(
        value: themeProvider,
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: const [ThemeToggleButton()],
            ),
          ),
        ),
      ),
    );

    // Initial state: starts dark, isDark is true -> displays light_mode_rounded
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_rounded), findsNothing);

    // Tap the button to toggle
    await tester.tap(find.byType(ThemeToggleButton));
    await tester.pumpAndSettle(); // Wait for animation

    // Should toggle to light mode: isDark is false -> displays dark_mode_rounded
    expect(themeProvider.isDark, isFalse);
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_rounded), findsNothing);
  });
}
