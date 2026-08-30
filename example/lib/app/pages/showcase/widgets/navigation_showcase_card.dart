import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../../../core/routes/app_route_names.dart';
import 'section_header.dart';

/// Card demonstrating declarative navigation with NanoRouter.
class NavigationShowcaseCard extends StatelessWidget {
  /// Creates a [NavigationShowcaseCard] widget.
  const NavigationShowcaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.navigation_outlined,
              title: 'Declarative NanoRouter & Navigation',
              subtitle: 'Navigate fluidly using context extensions or NanoRouter',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.toNamed(AppRouteNames.users),
                  icon: const Icon(Icons.people_outline),
                  label: const Text('Users List (/users)'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.toNamed(AppRouteNames.admin),
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Group Route (/admin/panel -> /login)'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.toNamed('/nao-existe'),
                  icon: const Icon(Icons.error_outline),
                  label: const Text('404 Not Found (/nao-existe)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
