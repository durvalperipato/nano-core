import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoThemeContext', () {
    testWidgets('exposes theme properties in light mode correctly', (
      tester,
    ) async {
      late ThemeData themeData;
      late ColorScheme colorScheme;
      late TextTheme textTheme;
      late bool isDark;
      late bool isLight;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                themeData = context.theme.data;
                colorScheme = context.theme.colors;
                textTheme = context.theme.text;
                isDark = context.theme.isDark;
                isLight = context.theme.isLight;
                return const Placeholder();
              },
            ),
          ),
        ),
      );

      expect(themeData.brightness, Brightness.light);
      expect(colorScheme.brightness, Brightness.light);
      expect(textTheme, isNotNull);
      expect(isDark, isFalse);
      expect(isLight, isTrue);
    });

    testWidgets('exposes theme properties in dark mode correctly', (
      tester,
    ) async {
      late ThemeData themeData;
      late ColorScheme colorScheme;
      late bool isDark;
      late bool isLight;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                themeData = context.theme.data;
                colorScheme = context.theme.colors;
                isDark = context.theme.isDark;
                isLight = context.theme.isLight;
                return const Placeholder();
              },
            ),
          ),
        ),
      );

      expect(themeData.brightness, Brightness.dark);
      expect(colorScheme.brightness, Brightness.dark);
      expect(isDark, isTrue);
      expect(isLight, isFalse);
    });
  });
}
