import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoContextExtensions', () {
    testWidgets('context.screen and context.theme return non-null instances', (
      tester,
    ) async {
      late NanoScreenContext screenContext;
      late NanoThemeContext themeContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                screenContext = context.screen;
                themeContext = context.theme;
                return const Placeholder();
              },
            ),
          ),
        ),
      );

      expect(screenContext, isNotNull);
      expect(themeContext, isNotNull);
      expect(screenContext.deviceType, isNotNull);
      expect(themeContext.isDark, isFalse);
    });
  });
}
