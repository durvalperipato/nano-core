import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoPoweredBy', () {
    testWidgets(
      'renders company name, prefix, version and logo in vertical mode',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NanoPoweredBy(
                companyName: 'NanoDevs',
                prefix: 'Desenvolvido por',
                version: 'v1.0.0',
                logo: Icon(Icons.code, key: Key('company_logo')),
              ),
            ),
          ),
        );

        expect(find.text('NanoDevs'), findsOneWidget);
        expect(find.text('Desenvolvido por'), findsOneWidget);
        expect(find.text('v1.0.0'), findsOneWidget);
        expect(find.byKey(const Key('company_logo')), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      },
    );

    testWidgets('renders in compact horizontal mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NanoPoweredBy(
              companyName: 'NanoDevs',
              prefix: 'Powered by',
              version: 'v1.0.0',
              isCompact: true,
              logo: Icon(Icons.code, key: Key('company_logo')),
            ),
          ),
        ),
      );

      expect(find.text('NanoDevs'), findsOneWidget);
      expect(find.text('Powered by'), findsOneWidget);
      expect(find.text(' • v1.0.0'), findsOneWidget);
      expect(find.byKey(const Key('company_logo')), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets(
      'renders with only company name when optional fields are null',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NanoPoweredBy(
                companyName: 'Acme Corp',
              ),
            ),
          ),
        );

        expect(find.text('Acme Corp'), findsOneWidget);
        expect(find.byType(Icon), findsNothing);
      },
    );

    testWidgets('triggers onTap callback when pressed', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NanoPoweredBy(
              companyName: 'NanoDevs',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('NanoDevs'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
    testWidgets(
      'automatically displays resolved version from NanoAppInfo '
      'when version is null',
      (tester) async {
        NanoAppInfo.setVersion('v1.0.5');

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NanoPoweredBy(
                companyName: 'NanoDevs',
              ),
            ),
          ),
        );

        expect(find.text('v1.0.5'), findsOneWidget);
        expect(find.text('NanoDevs'), findsOneWidget);

        NanoAppInfo.reset();
      },
    );
  });
}
