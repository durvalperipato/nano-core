import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';

/// Contextual modal sub-view presenting Nano Core architectural overview.
class ShowcaseInfoSubView extends StatelessWidget {
  /// Creates a [ShowcaseInfoSubView] widget.
  const ShowcaseInfoSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: .start,
            spacing: 16,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.architecture,
                      color: Color(0xFF6366F1),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Nano Core Studio',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Architecture & Design System Toolkit',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const Text(
                'This application is built with nano_core and demonstrates all '
                'major architectural pillars:',
              ),
              const Text('• Persistent Multi-Tab Shell (NanoShellScaffold)'),
              const Text('• Declarative Router & Dynamic Deep Links (:id, ?tab)'),
              const Text('• Native Skeleton & Wave Shimmer loading'),
              const Text('• Reactive Controllers & NanoCommand State Machines'),
              const Text('• Zero-configuration Smart Cache (0ms response)'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.shell.closeSubView(),
                  icon: const Icon(Icons.check),
                  label: const Text('Back to Showcase'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
