import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_trend_analyzer/state/theme_provider.dart';

void main() {
  group('ThemeProvider Tests', () {
    test('Initial mode should be dark', () {
      final provider = ThemeProvider();
      expect(provider.mode, ThemeMode.dark);
      expect(provider.isDark, isTrue);
    });

    test('toggle transitions from dark to light and back to dark', () {
      final provider = ThemeProvider();
      int listenerCalls = 0;
      provider.addListener(() {
        listenerCalls++;
      });

      provider.toggle();
      expect(provider.mode, ThemeMode.light);
      expect(provider.isDark, isFalse);
      expect(listenerCalls, 1);

      provider.toggle();
      expect(provider.mode, ThemeMode.dark);
      expect(provider.isDark, isTrue);
      expect(listenerCalls, 2);
    });
  });
}
