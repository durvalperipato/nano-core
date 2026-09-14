import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoShimmer', () {
    testWidgets('renders child widget with shimmer ShaderMask when enabled',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NanoShimmer(
              child: Text('Shimmering content'),
            ),
          ),
        ),
      );

      expect(find.text('Shimmering content'), findsOneWidget);
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('renders child directly without ShaderMask when disabled',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NanoShimmer(
              enabled: false,
              child: Text('Static content'),
            ),
          ),
        ),
      );

      expect(find.text('Static content'), findsOneWidget);
      expect(find.byType(ShaderMask), findsNothing);
    });

    testWidgets('accepts custom baseColor, highlightColor, and duration',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NanoShimmer(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              duration: Duration(seconds: 2),
              child: SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      final shimmerFinder = find.byType(NanoShimmer);
      expect(shimmerFinder, findsOneWidget);

      final NanoShimmer shimmer = tester.widget(shimmerFinder);
      expect(shimmer.baseColor, Colors.grey);
      expect(shimmer.highlightColor, Colors.white);
      expect(shimmer.duration, const Duration(seconds: 2));
      expect(shimmer.enabled, isTrue);
    });

    testWidgets('renders properly under dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: NanoShimmer(
              child: SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      expect(find.byType(ShaderMask), findsOneWidget);
    });
  });
}
