import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../../../core/routes/app_route_names.dart';
import 'section_header.dart';

/// Card demonstrating persistent navigation shell with NanoShellScaffold.
class ShellScaffoldShowcaseCard extends StatelessWidget {
  /// Creates a [ShellScaffoldShowcaseCard] widget.
  const ShellScaffoldShowcaseCard({super.key});

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
              icon: Icons.layers_outlined,
              title: 'Persistent NanoShellScaffold & Shell Navigation',
              subtitle:
                  'Multi-tab shell with keep-alive, contextual sub-views, and zero setState',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.toNamed(AppRouteNames.shellDemo),
                  icon: const Icon(Icons.tab_outlined),
                  label: const Text('Open Interactive Shell Demo (/shell-demo)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
