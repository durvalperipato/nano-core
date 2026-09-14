import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoSkeleton', () {
    testWidgets('box factory renders with dimensions and borderRadius',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoSkeleton.box(
              width: 120,
              height: 40,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

      expect(find.byType(NanoSkeleton), findsOneWidget);
      expect(find.byType(NanoShimmer), findsOneWidget);
    });

    testWidgets('circle factory renders with circular dimensions',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoSkeleton.circle(size: 64),
          ),
        ),
      );

      expect(find.byType(NanoSkeleton), findsOneWidget);
      expect(find.byType(NanoShimmer), findsOneWidget);
    });

    testWidgets('text factory renders requested number of lines',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoSkeleton.text(
              lines: 3,
              lineSpacing: 12.0,
            ),
          ),
        ),
      );

      expect(find.byType(NanoSkeleton), findsOneWidget);
      expect(find.byType(NanoShimmer), findsOneWidget);
    });

    testWidgets('card factory renders pre-assembled card structure',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoSkeleton.card(
              height: 180,
            ),
          ),
        ),
      );

      expect(find.byType(NanoSkeleton), findsOneWidget);
      expect(find.byType(NanoShimmer), findsOneWidget);
    });

    testWidgets('list factory renders multiple skeleton rows', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoSkeleton.list(
              items: 4,
            ),
          ),
        ),
      );

      expect(find.byType(NanoSkeleton), findsOneWidget);
      expect(find.byType(NanoShimmer), findsOneWidget);
    });

    testWidgets('grid factory renders rows and columns of cards',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoSkeleton.grid(
              columns: 3,
              rows: 2,
              itemHeight: 100,
            ),
          ),
        ),
      );

      expect(find.byType(NanoSkeleton), findsOneWidget);
      expect(find.byType(NanoShimmer), findsOneWidget);
    });

    group('mask factory', () {
      testWidgets('renders redacted shimmering mask when loading is true',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NanoSkeleton.mask(
                loading: true,
                child: const Text('Secret Account Number: 123456'),
              ),
            ),
          ),
        );

        expect(find.text('Secret Account Number: 123456'), findsOneWidget);
        expect(find.byType(NanoShimmer), findsOneWidget);
      });

      testWidgets(
          'renders child directly without shimmer when loading is false',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NanoSkeleton.mask(
                loading: false,
                child: const Text('Account Balance: \$1,000.00'),
              ),
            ),
          ),
        );

        expect(find.text('Account Balance: \$1,000.00'), findsOneWidget);
        expect(find.byType(ShaderMask), findsNothing);
      });
    });
  });
}
