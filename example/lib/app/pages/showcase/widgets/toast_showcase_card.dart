import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'section_header.dart';

/// Card component demonstrating multiplatform NanoToast notifications.
class ToastShowcaseCard extends StatelessWidget {
  const ToastShowcaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.notifications_active,
              title: 'NanoToast System',
              subtitle:
                  'Adaptive multiplatform toast notifications (Floating web card or SnackBar)',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    NanoToast.showSuccess(
                      context,
                      'Settings saved successfully to cloud storage.',
                    );
                  },
                  icon: const Icon(Icons.check, color: Color(0xFF10B981)),
                  label: const Text('Success Toast'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    NanoToast.showWarning(
                      context,
                      'Unsaved changes detected. Please save your work.',
                    );
                  },
                  icon: const Icon(Icons.warning, color: Color(0xFFF59E0B)),
                  label: const Text('Warning Toast'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    NanoToast.showError(
                      context,
                      'Network connection lost. Retrying in 5 seconds...',
                    );
                  },
                  icon: const Icon(Icons.error, color: Color(0xFFEF4444)),
                  label: const Text('Error Toast'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
