import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';

enum ShellDemoTab { feed, analytics, settings }

enum ShellDemoSubView { notifications }

/// Interactive demonstration page for [NanoShellScaffold].
class ShellDemoPage extends StatelessWidget {
  /// Creates a [ShellDemoPage] widget.
  const ShellDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NanoShellScaffold<ShellDemoTab, ShellDemoSubView>(
      initialTab: ShellDemoTab.feed,
      header: (context, controller) => AppBar(
        title: Text(
          controller.isShowingSubView
              ? 'Notifications'
              : switch (controller.currentTab) {
                  ShellDemoTab.feed => 'Feed (Persistent Tab 1)',
                  ShellDemoTab.analytics => 'Analytics (Persistent Tab 2)',
                  ShellDemoTab.settings => 'Settings (Persistent Tab 3)',
                  null => 'Shell Demo',
                },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Open Sub-View (Notifications)',
            onPressed: () {
              context.toSubView(ShellDemoSubView.notifications);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (context, controller) {
        if (controller.isShowingSubView) return null;

        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TabButton(
                  icon: Icons.rss_feed,
                  label: 'Feed',
                  isSelected: controller.currentTab == ShellDemoTab.feed,
                  onTap: () => controller.selectTab(ShellDemoTab.feed),
                ),
                _TabButton(
                  icon: Icons.bar_chart,
                  label: 'Analytics',
                  isSelected: controller.currentTab == ShellDemoTab.analytics,
                  onTap: () => controller.selectTab(ShellDemoTab.analytics),
                ),
                _TabButton(
                  icon: Icons.settings,
                  label: 'Settings',
                  isSelected: controller.currentTab == ShellDemoTab.settings,
                  onTap: () => controller.selectTab(ShellDemoTab.settings),
                ),
              ],
            ),
          ),
        );
      },
      tabs: [
        NanoShellTab(
          value: ShellDemoTab.feed,
          builder: (context) => const _DemoFeedView(),
        ),
        NanoShellTab(
          value: ShellDemoTab.analytics,
          builder: (context) => const _DemoAnalyticsView(),
        ),
        NanoShellTab(
          value: ShellDemoTab.settings,
          builder: (context) => const _DemoSettingsView(),
        ),
      ],
      subViews: [
        NanoShellSubView(
          id: ShellDemoSubView.notifications,
          builder: (context) => const _DemoNotificationsSubView(),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? theme.colorScheme.primary : Colors.grey,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DemoFeedView extends StatelessWidget {
  const _DemoFeedView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100, top: 16, left: 16, right: 16),
      itemCount: 20,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text('Feed Item #${index + 1}'),
          subtitle: const Text('State & scroll position preserved across tabs.'),
        ),
      ),
    );
  }
}

class _DemoAnalyticsView extends StatelessWidget {
  const _DemoAnalyticsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics_outlined, size: 64, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'Realtime Analytics Tab',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Switches immediately at 60fps with zero route reconstruction.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.toSubView(ShellDemoSubView.notifications);
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Open Contextual Sub-View'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoSettingsView extends StatelessWidget {
  const _DemoSettingsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings_outlined, size: 64, color: Colors.blueGrey),
          const SizedBox(height: 16),
          const Text(
            'Settings Tab',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.back(),
            child: const Text('Back to Showcase (/showcase)'),
          ),
        ],
      ),
    );
  }
}

class _DemoNotificationsSubView extends StatelessWidget {
  const _DemoNotificationsSubView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_active, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              const Text(
                'Contextual Sub-View (Notifications)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'This sub-view maintains the shell scaffold frame. Press Android back or the button below to return to the active tab.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.closeSubView();
                },
                icon: const Icon(Icons.close),
                label: const Text('Close Sub-View'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
