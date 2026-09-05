import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoLoadingOverlay', () {
    testWidgets('renders progress indicator or custom child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NanoLoadingOverlay(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NanoLoadingOverlay(
              child: Text('Custom Loader'),
            ),
          ),
        ),
      );

      expect(find.text('Custom Loader'), findsOneWidget);
    });
  });
}
