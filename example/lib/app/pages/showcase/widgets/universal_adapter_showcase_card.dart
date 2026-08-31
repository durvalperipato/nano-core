import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'section_header.dart';
import 'status_badge.dart';

/// Simulated external view state for testing adapters.
class AdapterDemoState extends NanoViewState {
  /// Creates an [AdapterDemoState] instance.
  const AdapterDemoState({this.label = 'Initial', this.counter = 0});

  /// The demo label.
  final String label;

  /// The demo counter.
  final int counter;

  @override
  List<Object?> get props => [label, counter];
}

/// Card showcasing [NanoStreamAdapter] and [NanoListenableAdapter].
class UniversalAdapterShowcaseCard extends StatefulWidget {
  /// Creates a [UniversalAdapterShowcaseCard] widget.
  const UniversalAdapterShowcaseCard({super.key});

  @override
  State<UniversalAdapterShowcaseCard> createState() =>
      _UniversalAdapterShowcaseCardState();
}

class _UniversalAdapterShowcaseCardState
    extends State<UniversalAdapterShowcaseCard> {
  // 1. Simulated Stream source (e.g. BLoC / Cubit)
  final _streamController = StreamController<String>.broadcast();
  late final NanoStreamAdapter<AdapterDemoState, String> _streamAdapter;

  // 2. Simulated Listenable source (e.g. MobX / ValueNotifier)
  final _notifier = ValueNotifier<int>(0);
  late final NanoListenableAdapter<AdapterDemoState> _listenableAdapter;

  @override
  void initState() {
    super.initState();

    _streamAdapter = NanoStreamAdapter<AdapterDemoState, String>(
      stream: _streamController.stream,
      initialState: const InitialState<AdapterDemoState>(),
      mapper: (event) {
        if (event == 'loading') return const LoadingState<AdapterDemoState>();
        if (event == 'error') return const ErrorState<AdapterDemoState>(null);
        return SuccessState(AdapterDemoState(label: event, counter: 1));
      },
    );

    _listenableAdapter = NanoListenableAdapter<AdapterDemoState>(
      listenable: _notifier,
      stateGetter: () => SuccessState(
        AdapterDemoState(
          label: 'ValueNotifier / MobX',
          counter: _notifier.value,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamController.close();
    _streamAdapter.dispose();
    _notifier.dispose();
    _listenableAdapter.dispose();
    super.dispose();
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
              icon: Icons.hub_outlined,
              title: 'Universal State Adapters',
              subtitle:
                  'Bridge any Stream (BLoC/Cubit) or Listenable (MobX/Signals)',
            ),
            const SizedBox(height: 16),

            // Stream Adapter section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '1. NanoStreamAdapter (BLoC / Cubit)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListenableBuilder(
                        listenable: _streamAdapter,
                        builder: (context, _) =>
                            _buildStatusBadge(_streamAdapter.state),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListenableBuilder(
                    listenable: _streamAdapter,
                    builder: (context, _) {
                      final state = _streamAdapter.state;
                      return Text(
                        'Current Payload: ${state.data?.label ?? 'No data'}',
                        style: TextStyle(color: Colors.grey.shade400),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.sync, size: 18),
                        label: const Text('Emit Loading'),
                        onPressed: () {
                          _streamController.add('loading');
                          NanoLog.info(
                            'Stream emitted loading event',
                            tag: 'StreamAdapter',
                          );
                        },
                      ),
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Emit Success'),
                        onPressed: () {
                          _streamController.add('BLoC User Loaded');
                          NanoLog.success(
                            'Stream emitted success data',
                            tag: 'StreamAdapter',
                          );
                        },
                      ),
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.error_outline, size: 18),
                        label: const Text('Emit Error'),
                        onPressed: () {
                          _streamController.add('error');
                          NanoLog.error(
                            'Stream emitted error event',
                            tag: 'StreamAdapter',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Listenable Adapter section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '2. NanoListenableAdapter (MobX / Signals)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListenableBuilder(
                        listenable: _listenableAdapter,
                        builder: (context, _) =>
                            _buildStatusBadge(_listenableAdapter.state),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListenableBuilder(
                    listenable: _listenableAdapter,
                    builder: (context, _) {
                      final state = _listenableAdapter.state;
                      return Text(
                        'Counter: ${state.data?.counter ?? 0}',
                        style: TextStyle(color: Colors.grey.shade400),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Increment ValueNotifier'),
                    onPressed: () {
                      _notifier.value++;
                      NLog.info(
                        'ValueNotifier updated: ${_notifier.value}',
                        tag: 'ListenableAdapter',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(NanoState<AdapterDemoState> state) {
    final (label, color) = switch (state) {
      LoadingState() => ('Loading', const Color(0xFFF59E0B)),
      SuccessState() => ('Success', const Color(0xFF10B981)),
      ErrorState() => ('Error', const Color(0xFFEF4444)),
      WarningState() => ('Warning', const Color(0xFFF97316)),
      _ => ('Initial', Colors.grey),
    };

    return StatusBadge(
      label: label,
      isActive: true,
      color: color,
    );
  }
}
