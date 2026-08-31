import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'section_header.dart';

/// Card component demonstrating [NanoLogger] / [NanoLog] capabilities.
class LoggerShowcaseCard extends StatelessWidget {
  /// Creates a [LoggerShowcaseCard] widget.
  const LoggerShowcaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.terminal,
              title: 'Structured Logger (NanoLogger / NanoLog)',
              subtitle:
                  'Color-coded ANSI logging with method context & telemetry',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Info Log'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                  ),
                  onPressed: () {
                    NanoLog.info(
                      'Showcase dashboard loaded',
                      tag: 'ShowcasePage',
                      method: 'build',
                      data: {'theme': 'dark', 'activeCards': 6},
                    );
                    NanoToast.showSuccess(
                      context,
                      'Info log emitted (check console!)',
                    );
                  },
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Success Log'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                  ),
                  onPressed: () {
                    NanoLog.success(
                      'Operation synchronized successfully',
                      tag: 'SyncEngine',
                      method: 'syncLocalData',
                      data: {'syncedCount': 42},
                    );
                    NanoToast.showSuccess(
                      context,
                      'Success log emitted (check console!)',
                    );
                  },
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.warning_amber_outlined),
                  label: const Text('Warning Log'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                  ),
                  onPressed: () {
                    NanoLog.warning(
                      'Response latency exceeded 800ms threshold',
                      tag: 'HttpClient',
                      method: 'getUsers',
                      data: {'durationMs': 1200},
                    );
                    NanoToast.showWarning(
                      context,
                      'Warning log emitted (check console!)',
                    );
                  },
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.error_outline),
                  label: const Text('Error Log'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                  ),
                  onPressed: () {
                    try {
                      throw StateError('Simulated database connection failure');
                    } catch (e, s) {
                      NanoLog.error(
                        'Failed to connect to local store',
                        tag: 'Database',
                        method: 'openSession',
                        data: {'dbName': 'nano_core.db'},
                        error: e,
                        stackTrace: s,
                      );
                    }
                    NanoToast.showError(
                      context,
                      'Error log with stackTrace emitted!',
                    );
                  },
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.language),
                  label: const Text('HTTP Log'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                  ),
                  onPressed: () {
                    NLog.http(
                      'https://api.nanodevs.com/v1/users',
                      httpMethod: 'GET',
                      statusCode: 200,
                      tag: 'NanoHttp',
                      method: 'onResponse',
                      data: {'records': 2, 'cached': false},
                    );
                    NanoToast.showSuccess(
                      context,
                      'HTTP log emitted (check console!)',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
