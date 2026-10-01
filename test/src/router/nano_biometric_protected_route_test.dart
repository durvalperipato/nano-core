import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';
import '../biometrics/mock_nano_biometrics.dart';

void main() {
  group('NanoBiometricProtectedRoute Widget Tests', () {
    late MockNanoBiometrics mock;

    setUp(() {
      mock = MockNanoBiometrics();
      if (GetIt.I.isRegistered<NanoBiometrics>()) {
        GetIt.I.unregister<NanoBiometrics>();
      }
    });

    tearDown(() {
      if (GetIt.I.isRegistered<NanoBiometrics>()) {
        GetIt.I.unregister<NanoBiometrics>();
      }
    });

    testWidgets(
      'renders protected content when biometric auth succeeds',
      (tester) async {
        final router = NanoRouter(
          initialRoute: '/vault',
          routes: [
            NanoRoute(
              path: '/fallback',
              builder: (context, _) => const Text('Fallback Screen'),
            ),
            NanoBiometricProtectedRoute(
              redirectTo: '/fallback',
              biometrics: mock,
              routes: [
                NanoRoute(
                  path: '/vault',
                  builder: (context, _) => const Text('Secret Vault Screen'),
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

        await tester.pumpAndSettle();

        expect(find.text('Secret Vault Screen'), findsOneWidget);
        expect(find.text('Fallback Screen'), findsNothing);
        expect(mock.authenticateCallCount, 1);
      },
    );

    testWidgets(
      'redirects to redirectTo when biometric hardware is unavailable',
      (tester) async {
        mock.isAvailableResult = false;

        final router = NanoRouter(
          initialRoute: '/vault',
          routes: [
            NanoRoute(
              path: '/fallback',
              builder: (context, _) => const Text('Fallback Screen'),
            ),
            NanoBiometricProtectedRoute(
              redirectTo: '/fallback',
              biometrics: mock,
              routes: [
                NanoRoute(
                  path: '/vault',
                  builder: (context, _) => const Text('Secret Vault Screen'),
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

        await tester.pumpAndSettle();

        expect(find.text('Fallback Screen'), findsOneWidget);
        expect(find.text('Secret Vault Screen'), findsNothing);
        expect(mock.isAvailableCallCount, 1);
        expect(mock.authenticateCallCount, 0);
      },
    );

    testWidgets(
      'redirects to redirectTo when authentication fails or is cancelled',
      (tester) async {
        mock.authenticateResult = false;

        final router = NanoRouter(
          initialRoute: '/vault',
          routes: [
            NanoRoute(
              path: '/fallback',
              builder: (context, _) => const Text('Fallback Screen'),
            ),
            NanoBiometricProtectedRoute(
              redirectTo: '/fallback',
              biometrics: mock,
              routes: [
                NanoRoute(
                  path: '/vault',
                  builder: (context, _) => const Text('Secret Vault Screen'),
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

        await tester.pumpAndSettle();

        expect(find.text('Fallback Screen'), findsOneWidget);
        expect(find.text('Secret Vault Screen'), findsNothing);
        expect(mock.authenticateCallCount, 1);
      },
    );

    testWidgets(
      'renders custom authBuilder and allows manual authentication trigger',
      (tester) async {
        final router = NanoRouter(
          initialRoute: '/vault',
          routes: [
            NanoRoute(
              path: '/fallback',
              builder: (context, _) => const Text('Fallback Screen'),
            ),
            NanoBiometricProtectedRoute(
              redirectTo: '/fallback',
              biometrics: mock,
              authBuilder: (context, onAuthenticate, onCancel) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Custom Lock Screen'),
                        ElevatedButton(
                          onPressed: onAuthenticate,
                          child: const Text('Unlock with Biometrics'),
                        ),
                        TextButton(
                          onPressed: onCancel,
                          child: const Text('Cancel Auth'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              routes: [
                NanoRoute(
                  path: '/vault',
                  builder: (context, _) => const Text('Secret Vault Screen'),
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

        await tester.pumpAndSettle();

        // Custom lock screen is rendered
        expect(find.text('Custom Lock Screen'), findsOneWidget);
        expect(find.text('Secret Vault Screen'), findsNothing);
        expect(mock.authenticateCallCount, 0);

        // Tap unlock button
        await tester.tap(find.text('Unlock with Biometrics'));
        await tester.pumpAndSettle();

        expect(find.text('Secret Vault Screen'), findsOneWidget);
        expect(mock.authenticateCallCount, 1);
      },
    );

    testWidgets(
      'triggers onCancel in custom authBuilder and redirects to redirectTo',
      (tester) async {
        final router = NanoRouter(
          initialRoute: '/vault',
          routes: [
            NanoRoute(
              path: '/fallback',
              builder: (context, _) => const Text('Fallback Screen'),
            ),
            NanoBiometricProtectedRoute(
              redirectTo: '/fallback',
              biometrics: mock,
              authBuilder: (context, onAuthenticate, onCancel) {
                return Scaffold(
                  body: Center(
                    child: TextButton(
                      onPressed: onCancel,
                      child: const Text('Cancel Auth'),
                    ),
                  ),
                );
              },
              routes: [
                NanoRoute(
                  path: '/vault',
                  builder: (context, _) => const Text('Secret Vault Screen'),
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

        await tester.pumpAndSettle();

        expect(find.text('Cancel Auth'), findsOneWidget);

        await tester.tap(find.text('Cancel Auth'));
        await tester.pumpAndSettle();

        expect(find.text('Fallback Screen'), findsOneWidget);
        expect(find.text('Secret Vault Screen'), findsNothing);
      },
    );

    testWidgets(
      'resolves NanoBiometrics from GetIt automatically if omitted in guard',
      (tester) async {
        GetIt.I.registerSingleton<NanoBiometrics>(mock);

        final router = NanoRouter(
          initialRoute: '/vault',
          routes: [
            NanoRoute(
              path: '/fallback',
              builder: (context, _) => const Text('Fallback Screen'),
            ),
            NanoBiometricProtectedRoute(
              redirectTo: '/fallback',
              routes: [
                NanoRoute(
                  path: '/vault',
                  builder: (context, _) => const Text('DI Vault Screen'),
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

        await tester.pumpAndSettle();

        expect(find.text('DI Vault Screen'), findsOneWidget);
        expect(mock.authenticateCallCount, 1);
      },
    );

    testWidgets(
      'redirects to redirectTo if NanoBiometrics is not registered and not '
      'provided',
      (tester) async {
        final router = NanoRouter(
          initialRoute: '/vault',
          routes: [
            NanoRoute(
              path: '/fallback',
              builder: (context, _) => const Text('Fallback Screen'),
            ),
            NanoBiometricProtectedRoute(
              redirectTo: '/fallback',
              routes: [
                NanoRoute(
                  path: '/vault',
                  builder: (context, _) => const Text('No Service Screen'),
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

        await tester.pumpAndSettle();

        expect(find.text('Fallback Screen'), findsOneWidget);
        expect(find.text('No Service Screen'), findsNothing);
      },
    );

    testWidgets(
      'passes contextual options to authenticate',
      (tester) async {
        final router = NanoRouter(
          initialRoute: '/vault',
          routes: [
            NanoRoute(
              path: '/fallback',
              builder: (context, _) => const Text('Fallback Screen'),
            ),
            NanoBiometricProtectedRoute(
              redirectTo: '/fallback',
              biometrics: mock,
              optionsBuilder: (context) => const NanoBiometricOptions(
                reason: 'Dynamic builder reason',
                biometricOnly: true,
              ),
              routes: [
                NanoRoute(
                  path: '/vault',
                  builder: (context, _) => const Text('Vault Screen'),
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

        await tester.pumpAndSettle();

        expect(find.text('Vault Screen'), findsOneWidget);
        expect(mock.lastOptionsUsed?.reason, 'Dynamic builder reason');
        expect(mock.lastOptionsUsed?.biometricOnly, isTrue);
      },
    );

    testWidgets(
      'displays custom loadingBuilder while authenticating',
      (tester) async {
        mock.delay = const Duration(milliseconds: 100);

        final router = NanoRouter(
          initialRoute: '/vault',
          routes: [
            NanoRoute(
              path: '/fallback',
              builder: (context, _) => const Text('Fallback Screen'),
            ),
            NanoBiometricProtectedRoute(
              redirectTo: '/fallback',
              biometrics: mock,
              loadingBuilder: (context) => const Scaffold(
                body: Center(child: Text('Custom Loading Feedback...')),
              ),
              routes: [
                NanoRoute(
                  path: '/vault',
                  builder: (context, _) => const Text('Vault Screen'),
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

        // Before completing delay
        await tester.pump();
        expect(find.text('Custom Loading Feedback...'), findsOneWidget);

        // Advance fake async clock through delays and settle
        await tester.pump(const Duration(milliseconds: 250));
        await tester.pumpAndSettle();
        expect(find.text('Vault Screen'), findsOneWidget);
      },
    );
  });
}
