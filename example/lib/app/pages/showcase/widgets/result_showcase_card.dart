import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../../../mocks/mock_models.dart';
import 'section_header.dart';

/// Card showcasing functional error handling with [NanoResult] and Dart 3
/// pattern matching.
class ResultShowcaseCard extends StatefulWidget {
  /// Creates a [ResultShowcaseCard] widget.
  const ResultShowcaseCard({super.key});

  @override
  State<ResultShowcaseCard> createState() => _ResultShowcaseCardState();
}

class _ResultShowcaseCardState extends State<ResultShowcaseCard> {
  NanoResult<MockUser, String>? _lastResult;

  void _simulateSuccess() {
    setState(() {
      _lastResult = const NanoResult.success(
        MockUser(
          id: '1',
          name: 'Sarah Connor',
          email: 'sarah@skynet.dev',
          role: 'Admin',
        ),
      );
    });
  }

  void _simulateFailure() {
    setState(() {
      _lastResult = const NanoResult.failure(
        'AuthenticationFailed: Invalid token or expired session',
      );
    });
  }

  Future<void> _simulateRunAsync() async {
    final result = await NanoResult.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return const MockUser(
        id: '2',
        name: 'John Doe',
        email: 'john@flutter.dev',
        role: 'Developer',
      );
    });

    setState(() {
      _lastResult = result.mapError((err) => err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.shield_outlined,
              title: 'Functional Results (NanoResult<S, F>)',
              subtitle:
                  'Type-safe outcomes with compile-time Dart 3 Pattern Matching',
            ),
            const SizedBox(height: 16),

            // Live result preview box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _lastResult == null
                              ? Colors.grey.withValues(alpha: 0.2)
                              : _lastResult!.isSuccess
                                  ? const Color(0xFF10B981)
                                      .withValues(alpha: 0.2)
                                  : const Color(0xFFEF4444)
                                      .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _lastResult == null
                              ? 'AWAITING ACTION'
                              : _lastResult!.isSuccess
                                  ? 'NANOSUCCESS<User, String>'
                                  : 'NANOFAILURE<User, String>',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _lastResult == null
                                ? Colors.grey
                                : _lastResult!.isSuccess
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    switch (_lastResult) {
                      null => '// Click a button below to evaluate a NanoResult',
                      NanoSuccess(:final data) =>
                        '✅ User: ${data.name} (${data.email}) [Role: ${data.role}]',
                      NanoFailure(:final error) => '❌ Error: $error',
                    },
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: _lastResult == null
                          ? Colors.grey
                          : _lastResult!.isSuccess
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action triggers
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Simulate NanoSuccess'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                  ),
                  onPressed: _simulateSuccess,
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.error_outline, size: 18),
                  label: const Text('Simulate NanoFailure'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                  ),
                  onPressed: _simulateFailure,
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.auto_mode, size: 18),
                  label: const Text('NanoResult.runAsync(...)'),
                  onPressed: _simulateRunAsync,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
