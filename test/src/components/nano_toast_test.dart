import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoToast', () {
    testWidgets('showSuccess renders a SnackBar on mobile layout', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    NanoToast.showSuccess(context, 'Success message'),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Success message'), findsOneWidget);
    });

    testWidgets('showError and showWarning trigger toast display', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        NanoToast.showError(context, 'Error message'),
                    child: const Text('Error'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        NanoToast.showWarning(context, 'Warning message'),
                    child: const Text('Warning'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Error'));
      await tester.pump();
      expect(find.text('Error message'), findsOneWidget);

      await tester.tap(find.text('Warning'));
      await tester.pump();
      expect(find.text('Warning message'), findsOneWidget);
    });
  });
}
