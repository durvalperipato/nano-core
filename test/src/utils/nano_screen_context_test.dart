import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoScreenContext', () {
    testWidgets('evaluates mobile viewport properties accurately', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(500, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      late bool isMobile;
      late bool isTablet;
      late bool isDesktop;
      late double width;
      late double height;
      late Size size;
      late NanoDeviceType deviceType;
      late String responsiveValueWithTablet;
      late String responsiveValueFallback;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                isMobile = context.screen.isMobile;
                isTablet = context.screen.isTablet;
                isDesktop = context.screen.isDesktop;
                width = context.screen.width;
                height = context.screen.height;
                size = context.screen.size;
                deviceType = context.screen.deviceType;
                responsiveValueWithTablet = context.screen.responsive(
                  mobile: 'mobile_val',
                  desktop: 'desktop_val',
                  tablet: 'tablet_val',
                );
                responsiveValueFallback = context.screen.responsive(
                  mobile: 'mobile_val',
                  desktop: 'desktop_val',
                );
                return const Placeholder();
              },
            ),
          ),
        ),
      );

      expect(isMobile, isTrue);
      expect(isTablet, isFalse);
      expect(isDesktop, isFalse);
      expect(width, 500);
      expect(height, 900);
      expect(size, const Size(500, 900));
      expect(deviceType, NanoDeviceType.mobile);
      expect(responsiveValueWithTablet, 'mobile_val');
      expect(responsiveValueFallback, 'mobile_val');
    });

    testWidgets(
      'evaluates tablet viewport properties and defaults to desktop',
      (tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      late bool isMobile;
      late bool isTablet;
      late bool isDesktop;
      late NanoDeviceType deviceType;
      late String responsiveValueWithTablet;
      late String responsiveValueFallback;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                isMobile = context.screen.isMobile;
                isTablet = context.screen.isTablet;
                isDesktop = context.screen.isDesktop;
                deviceType = context.screen.deviceType;
                responsiveValueWithTablet = context.screen.responsive(
                  mobile: 'mobile_val',
                  desktop: 'desktop_val',
                  tablet: 'tablet_val',
                );
                responsiveValueFallback = context.screen.responsive(
                  mobile: 'mobile_val',
                  desktop: 'desktop_val',
                );
                return const Placeholder();
              },
            ),
          ),
        ),
      );

      expect(isMobile, isFalse);
      expect(isTablet, isTrue);
      expect(isDesktop, isFalse);
      expect(deviceType, NanoDeviceType.tablet);
      expect(responsiveValueWithTablet, 'tablet_val');
      expect(responsiveValueFallback, 'desktop_val');
    });

    testWidgets('evaluates desktop viewport properties accurately', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      late bool isMobile;
      late bool isTablet;
      late bool isDesktop;
      late NanoDeviceType deviceType;
      late String responsiveValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                isMobile = context.screen.isMobile;
                isTablet = context.screen.isTablet;
                isDesktop = context.screen.isDesktop;
                deviceType = context.screen.deviceType;
                responsiveValue = context.screen.responsive(
                  mobile: 'mobile_val',
                  desktop: 'desktop_val',
                  tablet: 'tablet_val',
                );
                return const Placeholder();
              },
            ),
          ),
        ),
      );

      expect(isMobile, isFalse);
      expect(isTablet, isFalse);
      expect(isDesktop, isTrue);
      expect(deviceType, NanoDeviceType.desktop);
      expect(responsiveValue, 'desktop_val');
    });
  });
}
