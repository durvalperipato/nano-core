import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../showcase_controller.dart';
import 'section_header.dart';

/// Card component demonstrating reactive state simulation with NanoState.
class StateSimulatorCard extends StatelessWidget {
  /// Associated controller instance.
  final ShowcaseController controller;

  /// Creates a [StateSimulatorCard] widget.
  const StateSimulatorCard({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.alt_route,
              title: 'Reactive State Machine (NanoState)',
              subtitle:
                  'Trigger state updates observed automatically '
                  'by NanoScaffold',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  _StateStatusIcon(state: state),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Status: ${_getStateName(state)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getStateColor(state),
                          ),
                        ),
                        if (state.data?.message != null)
                          Text(
                            state.data!.message!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        if (state case WarningState s)
                          Text(
                            s.key?.message(context) ?? 'Aviso genérico',
                            style: TextStyle(color: _getStateColor(state)),
                          ),
                        if (state case ErrorState s)
                          Text(
                            s.key?.message(context) ?? 'Erro genérico',
                            style: TextStyle(color: _getStateColor(state)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.simulateSuccess,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Simulate Success'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.simulateWarning,
                  icon: const Icon(Icons.warning_amber_outlined),
                  label: const Text('Simulate Warning'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.simulateError,
                  icon: const Icon(Icons.error_outline),
                  label: const Text('Simulate Error'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.simulateGlobalFetch,
                  icon: const Icon(Icons.cloud_download_outlined),
                  label: const Text('Global Fetch (Overlay)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStateName(NanoState state) {
    return switch (state) {
      InitialState() => 'INITIAL',
      LoadingState() => 'LOADING',
      SuccessState() => 'SUCCESS',
      WarningState() => 'WARNING',
      ErrorState() => 'ERROR',
    };
  }

  Color _getStateColor(NanoState state) {
    if (state is SuccessState) return const Color(0xFF10B981);
    if (state is WarningState) return const Color(0xFFF59E0B);
    if (state is ErrorState) return const Color(0xFFEF4444);
    return Colors.white70;
  }
}

class _StateStatusIcon extends StatelessWidget {
  const _StateStatusIcon({required this.state});

  final NanoState state;

  @override
  Widget build(BuildContext context) {
    if (state is LoadingState) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }
    if (state is SuccessState) {
      return const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28);
    }
    if (state is WarningState) {
      return const Icon(Icons.warning, color: Color(0xFFF59E0B), size: 28);
    }
    if (state is ErrorState) {
      return const Icon(Icons.error, color: Color(0xFFEF4444), size: 28);
    }
    return const Icon(Icons.info_outline, color: Colors.blueAccent, size: 28);
  }
}
