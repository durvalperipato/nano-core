import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

enum RouterTab { feed, messages }

enum RouterSubView { compose }

void main() {
  group('NanoRouter', () {
    testWidgets('navigates to standard route matching path', (tester) async {
      final router = NanoRouter(
        initialRoute: '/home',
        routes: [
          NanoRoute(
            path: '/home',
            builder: (context, _) => const Text('Home Screen'),
          ),
          NanoRoute(
            path: '/profile',
            builder: (context, _) => const Text('Profile Screen'),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: NanoRouter.navigatorKey,
          onGenerateRoute: router.onGenerateRoute,
          initialRoute: router.initialRoute,
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);

      NanoRouter.navigatorKey.currentState?.pushNamed('/profile');
      await tester.pumpAndSettle();

      expect(find.text('Profile Screen'), findsOneWidget);
    });

    testWidgets('registers and navigates to shells list parameter', (
      tester,
    ) async {
      final router = NanoRouter(
        initialRoute: '/app',
        routes: [
          NanoRoute(
            path: '/login',
            builder: (context, _) => const Text('Login Screen'),
          ),
        ],
        shells: [
          NanoShellRoute<RouterTab, RouterSubView>(
            path: '/app',
            initialTab: RouterTab.feed,
            tabs: [
              NanoShellTab(
                value: RouterTab.feed,
                builder: (context) => const Text('Feed Screen'),
              ),
              NanoShellTab(
                value: RouterTab.messages,
                builder: (context) => const Text('Messages Screen'),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: NanoRouter.navigatorKey,
          onGenerateRoute: router.onGenerateRoute,
          initialRoute: router.initialRoute,
        ),
      );

      expect(find.text('Feed Screen'), findsOneWidget);
    });
  });
}
