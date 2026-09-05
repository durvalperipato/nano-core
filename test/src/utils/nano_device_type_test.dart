import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoDeviceType', () {
    testWidgets('evaluates mobile, tablet and desktop dimensions properly', (
      tester,
    ) async {
      late NanoDeviceType detectedType;

      Widget buildTest(Size size) {
        return MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: size),
            child: Builder(
              builder: (context) {
                detectedType = NanoDeviceType.fromContext(context);
                return Text('Size: ${size.width}x${size.height}');
              },
            ),
          ),
        );
      }

      // Mobile screen (< 600 width)
      await tester.pumpWidget(buildTest(const Size(375, 812)));
      expect(detectedType, equals(NanoDeviceType.mobile));

      // Tablet screen (>= 600 and < 1024 width)
      await tester.pumpWidget(buildTest(const Size(768, 1024)));
      expect(detectedType, equals(NanoDeviceType.tablet));

      // Desktop screen (>= 1024 width)
      await tester.pumpWidget(buildTest(const Size(1440, 900)));
      expect(detectedType, equals(NanoDeviceType.desktop));
    });

    test('isWeb matches kIsWeb flag', () {
      expect(NanoDeviceType.isWeb, equals(false));
    });
  });
}
