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

    testWidgets('renders bottomNavigationBar and switches tab', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NanoShellScaffold<TestTab, TestSubView>(
            initialTab: TestTab.home,
            bottomNavigationBar: (context, controller) => BottomNavigationBar(
              currentIndex: controller.currentTab == TestTab.home ? 0 : 1,
              onTap: (index) => controller.selectTab(
                index == 0 ? TestTab.home : TestTab.profile,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
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
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile Screen'), findsOneWidget);
    });

    testWidgets('custom layout wrapper builder wraps body content', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NanoShellScaffold<TestTab, TestSubView>(
            initialTab: TestTab.home,
            builder: (context, controller, body) => Column(
              children: [
                const Text('Custom Shell Wrapper Header'),
                Expanded(child: body),
              ],
            ),
            tabs: [
              NanoShellTab(
                value: TestTab.home,
                builder: (context) => const Text('Wrapped Tab Body'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Custom Shell Wrapper Header'), findsOneWidget);
      expect(find.text('Wrapped Tab Body'), findsOneWidget);
    });

    testWidgets('switches tab content smoothly using context.shell.selectTab', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NanoShellScaffold<TestTab, TestSubView>(
            initialTab: TestTab.home,
            floatingActionButton: (context, controller) => ElevatedButton(
              onPressed: () => context.shell.selectTab(TestTab.profile),
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

    testWidgets(
      'opens subView via context.shell.openSubView and closes via '
      'context.shell.closeSubView',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: NanoShellScaffold<TestTab, TestSubView>(
              initialTab: TestTab.home,
              floatingActionButton: (context, controller) =>
                  Text('SubView Open: ${context.shell.isSubViewOpen()}'),
              tabs: [
                NanoShellTab(
                  value: TestTab.home,
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      context.shell.openSubView(TestSubView.notifications);
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
                      context.shell.closeSubView();
                    },
                    child: const Text('Close Notifications'),
                  ),
                ),
              ],
            ),
          ),
        );

        expect(find.text('SubView Open: false'), findsOneWidget);

        // Open subview
        await tester.tap(find.text('Open Notifications'));
        await tester.pumpAndSettle();

        expect(find.text('Close Notifications'), findsOneWidget);
        expect(find.text('SubView Open: true'), findsOneWidget);

        // Close subview
        await tester.tap(find.text('Close Notifications'));
        await tester.pumpAndSettle();

        expect(find.text('Open Notifications'), findsOneWidget);
        expect(find.text('SubView Open: false'), findsOneWidget);
      },
    );
  });
}
