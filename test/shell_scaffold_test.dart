import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

enum TestTab { home, profile }

enum TestSubView { notifications }

void main() {
  group('NanoShellScaffold', () {
    testWidgets('renders initial tab content, headers and FAB via controller', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NanoShellScaffold<TestTab, TestSubView>(
            initialTab: TestTab.home,
            header: (context, controller) => AppBar(
              title: Text(
                controller.currentTab == TestTab.home
                    ? 'Home Header'
                    : 'Profile Header',
              ),
            ),
            floatingActionButton: (context, controller) => FloatingActionButton(
              onPressed: () {},
              child: Text(controller.effectiveActiveTab?.name ?? 'none'),
            ),
            tabs: [
              NanoShellTab(
                value: TestTab.home,
                builder: (context) => const Text('Home Screen'),
              ),
              NanoShellTab(
                value: TestTab.profile,
                builder: (context) => const Text('Profile Screen'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Home Header'), findsOneWidget);
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('switches tab content smoothly using context.toTab', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NanoShellScaffold<TestTab, TestSubView>(
            initialTab: TestTab.home,
            floatingActionButton: (context, controller) => ElevatedButton(
              onPressed: () => context.toTab(TestTab.profile),
              child: const Text('Go to Profile'),
            ),
            tabs: [
              NanoShellTab(
                value: TestTab.home,
                builder: (context) => const Text('Home Screen'),
              ),
              NanoShellTab(
                value: TestTab.profile,
                builder: (context) => const Text('Profile Screen'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);

      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile Screen'), findsOneWidget);
    });

    testWidgets('opens subView via context.toSubView and closes subView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NanoShellScaffold<TestTab, TestSubView>(
            initialTab: TestTab.home,
            floatingActionButton: (context, controller) => Text(
              'FAB tab: ${controller.effectiveActiveTab?.name}',
            ),
            tabs: [
              NanoShellTab(
                value: TestTab.home,
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    context.toSubView(TestSubView.notifications);
                  },
                  child: const Text('Open Notifications'),
                ),
              ),
            ],
            subViews: [
              NanoShellSubView(
                id: TestSubView.notifications,
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    context.closeSubView();
                  },
                  child: const Text('Close Notifications'),
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.text('FAB tab: home'), findsOneWidget);

      // Open subview
      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      expect(find.text('Close Notifications'), findsOneWidget);
      expect(find.text('FAB tab: null'), findsOneWidget);

      // Close subview
      await tester.tap(find.text('Close Notifications'));
      await tester.pumpAndSettle();

      expect(find.text('Open Notifications'), findsOneWidget);
      expect(find.text('FAB tab: home'), findsOneWidget);
    });
  });
}
