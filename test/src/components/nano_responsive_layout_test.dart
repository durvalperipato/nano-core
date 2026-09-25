import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoResponsiveLayout', () {
    testWidgets('renders mobile builder when viewport width is mobile', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoResponsiveLayout(
              mobile: (context) => const Text('Mobile View'),
              desktop: (context) => const Text('Desktop View'),
              tablet: (context) => const Text('Tablet View'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile View'), findsOneWidget);
      expect(find.text('Desktop View'), findsNothing);
      expect(find.text('Tablet View'), findsNothing);
    });

    testWidgets('renders tablet builder when provided on tablet viewport', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoResponsiveLayout(
              mobile: (context) => const Text('Mobile View'),
              desktop: (context) => const Text('Desktop View'),
              tablet: (context) => const Text('Tablet View'),
            ),
          ),
        ),
      );

      expect(find.text('Tablet View'), findsOneWidget);
      expect(find.text('Mobile View'), findsNothing);
      expect(find.text('Desktop View'), findsNothing);
    });

    testWidgets(
      'defaults to desktop builder on tablet when tablet is omitted',
      (tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoResponsiveLayout(
              mobile: (context) => const Text('Mobile View'),
              desktop: (context) => const Text('Desktop View'),
            ),
          ),
        ),
      );

      expect(find.text('Desktop View'), findsOneWidget);
      expect(find.text('Mobile View'), findsNothing);
    });

    testWidgets('renders desktop builder on desktop viewport', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoResponsiveLayout(
              mobile: (context) => const Text('Mobile View'),
              desktop: (context) => const Text('Desktop View'),
              tablet: (context) => const Text('Tablet View'),
            ),
          ),
        ),
      );

      expect(find.text('Desktop View'), findsOneWidget);
      expect(find.text('Mobile View'), findsNothing);
      expect(find.text('Tablet View'), findsNothing);
    });
  });

  group('NanoResponsiveLayout.flex', () {
    testWidgets('renders as Row on desktop and Column on mobile with spacing', (
      tester,
    ) async {
      // 1. Desktop test
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NanoResponsiveLayout.flex(
              spacing: 16.0,
              children: [
                Text('First'),
                Text('Second'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);

      // Verify horizontal spacer SizedBox(width: 16)
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final spacer = sizedBoxes.firstWhere((box) => box.width == 16.0);
      expect(spacer.width, 16.0);

      // 2. Mobile test
      tester.view.physicalSize = const Size(400, 800);
      await tester.pump();

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);

      // Verify vertical spacer SizedBox(height: 16)
      final mobileSizedBoxes = tester.widgetList<SizedBox>(
        find.byType(SizedBox),
      );
      final verticalSpacer = mobileSizedBoxes.firstWhere(
        (box) => box.height == 16.0,
      );
      expect(verticalSpacer.height, 16.0);
    });

    testWidgets(
      'reverses children order on mobile when reverseOnMobile is true',
      (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NanoResponsiveLayout.flex(
              reverseOnMobile: true,
              children: [
                Text('Item 1'),
                Text('Item 2'),
              ],
            ),
          ),
        ),
      );

      final columnFinder = find.byType(Column);
      expect(columnFinder, findsOneWidget);

      final column = tester.widget<Column>(columnFinder);
      expect((column.children.first as Text).data, 'Item 2');
      expect((column.children.last as Text).data, 'Item 1');
    });
  });
}
