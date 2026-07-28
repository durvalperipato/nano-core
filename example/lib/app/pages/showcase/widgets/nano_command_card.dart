import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../showcase_controller.dart';
import 'section_header.dart';

/// Card component demonstrating NanoCommand and NanoCommandBuilder.
class NanoCommandCard extends StatelessWidget {
  const NanoCommandCard({super.key, required this.controller});

  final ShowcaseController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.touch_app,
              title: 'NanoCommand & NanoCommandBuilder',
              subtitle:
                  'Encapsulate asynchronous user actions with built-in reactive state',
            ),
            const SizedBox(height: 16),
            NanoCommandBuilder<String>(
              command: controller.fetchUserCommand,
              builder: (context, state) {
                final isLoading = state.isLoading;
                final data = state.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => controller.fetchUserCommand.execute(),
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.download),
                      label: Text(
                        isLoading
                            ? 'Executing Command...'
                            : 'Execute Fetch User Command',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    if (data != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Command Output: $data',
                          style: const TextStyle(
                            color: Color(0xFFA5B4FC),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
