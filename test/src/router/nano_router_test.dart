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

    testWidgets(
      'NanoProtectedRoute wraps and guards NanoShellRoute via NanoRouteBase',
      (tester) async {
        const hasAccess = false;

        final router = NanoRouter(
          initialRoute: '/app',
          routes: [
            NanoRoute(
              path: '/login',
              builder: (context, _) => const Text('Login Screen'),
            ),
            NanoProtectedRoute(
              hasAccess: (context, args) => hasAccess,
              redirectTo: '/login',
              routes: [
                NanoShellRoute<RouterTab, RouterSubView>(
                  path: '/app',
                  initialTab: RouterTab.feed,
                  tabs: [
                    NanoShellTab(
                      value: RouterTab.feed,
                      builder: (context) => const Text('Protected Feed'),
                    ),
                  ],
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

        // Access denied -> redirects to /login
        await tester.pumpAndSettle();
        expect(find.text('Login Screen'), findsOneWidget);
        expect(find.text('Protected Feed'), findsNothing);
      },
    );

    testWidgets(
      'matches dynamic route with path parameters and query parameters',
      (tester) async {
      final router = NanoRouter(
        initialRoute: '/home',
        routes: [
          NanoRoute(
            path: '/home',
            builder: (context, _) => const Text('Home Screen'),
          ),
          NanoRoute(
            path: '/users/:id',
            builder: (context, args) {
              final id = args.pathParam('id');
              final tab = args.queryParam('tab') ?? 'none';
              return Text('User $id tab $tab');
            },
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

      NanoRouter.navigatorKey.currentState?.pushNamed('/users/42?tab=reviews');
      await tester.pumpAndSettle();

      expect(find.text('User 42 tab reviews'), findsOneWidget);
    });

    testWidgets(
      'NanoDetailsRoute automatically extracts path parameter when data '
      'is omitted',
      (tester) async {
      final router = NanoRouter(
        initialRoute: '/home',
        routes: [
          NanoRoute(
            path: '/home',
            builder: (context, _) => const Text('Home Screen'),
          ),
          NanoDetailsRoute<String>(
            path: '/products/:id',
            builder: (context, id) => Text('Product ID: $id'),
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

      NanoRouter.navigatorKey.currentState?.pushNamed('/products/999');
      await tester.pumpAndSettle();

      expect(find.text('Product ID: 999'), findsOneWidget);
    });
  });
}
