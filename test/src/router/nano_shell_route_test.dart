import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

enum DemoTab { overview, settings }

enum DemoSubView { help }

void main() {
  group('NanoShellRoute', () {
    testWidgets('renders shell scaffold and matches route path', (
      tester,
    ) async {
      final shellRoute = NanoShellRoute<DemoTab, DemoSubView>(
        path: '/dashboard',
        initialTab: DemoTab.overview,
        tabs: [
          NanoShellTab(
            value: DemoTab.overview,
            builder: (context) => const Text('Overview Tab Screen'),
          ),
          NanoShellTab(
            value: DemoTab.settings,
            builder: (context) => const Text('Settings Tab Screen'),
          ),
        ],
      );

      expect(shellRoute.path, '/dashboard');

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => shellRoute.builder(
              context,
              const NanoRouteArgs(data: '/dashboard'),
            ),
          ),
        ),
      );

      expect(find.text('Overview Tab Screen'), findsOneWidget);
    });

    testWidgets('renders custom layout wrapper builder in NanoShellRoute', (
      tester,
    ) async {
      final shellRoute = NanoShellRoute<DemoTab, DemoSubView>(
        path: '/dashboard',
        initialTab: DemoTab.overview,
        builder: (context, controller, body) => Scaffold(
          body: Column(
            children: [
              const Text('Custom Header In Route'),
              Expanded(child: body),
            ],
          ),
          bottomNavigationBar:
              Text('Active Tab: ${controller.currentTab?.name}'),
        ),
        tabs: [
          NanoShellTab(
            value: DemoTab.overview,
            builder: (context) => const Text('Overview Content'),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => shellRoute.builder(
              context,
              const NanoRouteArgs(),
            ),
          ),
        ),
      );

      expect(find.text('Active Tab: overview'), findsOneWidget);
      expect(find.text('Custom Header In Route'), findsOneWidget);
      expect(find.text('Overview Content'), findsOneWidget);
    });
  });
}
