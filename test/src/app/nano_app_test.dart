import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoApp', () {
    testWidgets('renders home widget when router is not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const NanoApp(
          home: Scaffold(
            body: Text('Direct Home Page'),
          ),
        ),
      );

      expect(find.text('Direct Home Page'), findsOneWidget);
    });

    testWidgets('configures NanoRouter correctly when router is provided', (
      tester,
    ) async {
      final router = NanoRouter(
        initialRoute: '/initial',
        routes: [
          NanoRoute(
            path: '/initial',
            builder: (context, _) => const Scaffold(
              body: Text('Router Initial View'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        NanoApp(router: router),
      );

      expect(find.text('Router Initial View'), findsOneWidget);
    });
  });
}
