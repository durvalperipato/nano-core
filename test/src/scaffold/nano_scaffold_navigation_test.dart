import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nano_core/nano_core.dart';

class _NavigationViewState extends NanoViewState {
  const _NavigationViewState();

  @override
  List<Object?> get props => [];
}

class _NavigationTestController extends NanoController<_NavigationViewState> {
  _NavigationTestController()
    : super(initialState: const _NavigationViewState());

  @override
  Future<void> init(String? id) async {}
}

void main() {
  group('NanoScaffold Reactive Navigation', () {
    late _NavigationTestController controller;

    setUp(() {
      controller = _NavigationTestController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('autoNavigate triggers Navigator transition automatically', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) =>
                NanoScaffold<_NavigationViewState, NanoMessageKey>(
                  controller: controller,
                  builder: (context, state) => const Text('Root Page'),
                ),
            '/details': (context) => const Text('Details Page'),
          },
        ),
      );

      expect(find.text('Root Page'), findsOneWidget);
      expect(find.text('Details Page'), findsNothing);

      controller.emitNavigation('/details');
      await tester.pumpAndSettle();

      expect(find.text('Details Page'), findsOneWidget);
    });

    testWidgets(
      'onNavigate returning true intercepts and cancels autoNavigate',
      (tester) async {
        NanoNavigationEvent? interceptedEvent;

        await tester.pumpWidget(
          MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) =>
                  NanoScaffold<_NavigationViewState, NanoMessageKey>(
                    controller: controller,
                    onNavigate: (context, event) {
                      interceptedEvent = event;
                      return true;
                    },
                    builder: (context, state) => const Text('Root Page'),
                  ),
              '/details': (context) => const Text('Details Page'),
            },
          ),
        );

        controller.emitNavigation('/details');
        await tester.pumpAndSettle();

        expect(interceptedEvent?.routeName, equals('/details'));
        expect(find.text('Root Page'), findsOneWidget);
        expect(find.text('Details Page'), findsNothing);
      },
    );

    testWidgets('onNavigate returning false delegates to autoNavigate', (
      tester,
    ) async {
      NanoNavigationEvent? interceptedEvent;

      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) =>
                NanoScaffold<_NavigationViewState, NanoMessageKey>(
                  controller: controller,
                  onNavigate: (context, event) {
                    interceptedEvent = event;
                    return false;
                  },
                  builder: (context, state) => const Text('Root Page'),
                ),
            '/details': (context) => const Text('Details Page'),
          },
        ),
      );

      controller.emitNavigation('/details');
      await tester.pumpAndSettle();

      expect(interceptedEvent?.routeName, equals('/details'));
      expect(find.text('Details Page'), findsOneWidget);
    });

    testWidgets('autoNavigate false prevents automatic transition', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) =>
                NanoScaffold<_NavigationViewState, NanoMessageKey>(
                  controller: controller,
                  autoNavigate: false,
                  builder: (context, state) => const Text('Root Page'),
                ),
            '/details': (context) => const Text('Details Page'),
          },
        ),
      );

      controller.emitNavigation('/details');
      await tester.pumpAndSettle();

      expect(find.text('Root Page'), findsOneWidget);
      expect(find.text('Details Page'), findsNothing);
    });
  });
}
