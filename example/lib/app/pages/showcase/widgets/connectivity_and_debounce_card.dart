import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'section_header.dart';

class ConnectivityAndDebounceCard extends StatefulWidget {
  const ConnectivityAndDebounceCard({super.key});

  @override
  State<ConnectivityAndDebounceCard> createState() =>
      _ConnectivityAndDebounceCardState();
}

class _ConnectivityAndDebounceCardState
    extends State<ConnectivityAndDebounceCard> {
  final NanoConnectivity _connectivity =
      NanoConnectivity(initialStatus: NanoConnectivityStatus.wifi);

  String _debouncedText = '';

  @override
  void dispose() {
    _connectivity.dispose();
    super.dispose();
  }

  IconData _getStatusIcon(NanoConnectivityStatus status) {
    return switch (status) {
      NanoConnectivityStatus.wifi => Icons.wifi,
      NanoConnectivityStatus.cellular => Icons.signal_cellular_alt,
      NanoConnectivityStatus.ethernet => Icons.settings_ethernet,
      NanoConnectivityStatus.bluetooth => Icons.bluetooth,
      NanoConnectivityStatus.vpn => Icons.vpn_lock,
      NanoConnectivityStatus.none => Icons.wifi_off,
      NanoConnectivityStatus.unknown => Icons.help_outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Connectivity & Debounce Search',
              subtitle:
                  'Reactive network monitoring (Wi-Fi, 4G/5G, Ethernet) & debounce tools',
              icon: Icons.wifi,
            ),
            const SizedBox(height: 16),

            // 1. Connectivity Demonstration
            Text(
              '1. NanoConnectivity Observable',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: _connectivity,
              builder: (context, _) {
                final isOnline = _connectivity.isOnline;
                final status = _connectivity.status;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isOnline ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getStatusIcon(status),
                            color: isOnline ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isOnline
                                      ? 'Online (${status.name.toUpperCase()})'
                                      : 'Offline (No Connection)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isOnline
                                        ? Colors.green[800]
                                        : Colors.red[800],
                                  ),
                                ),
                                Text(
                                  'isWifi: ${status.isWifi} | isCellular: ${status.isCellular} | isEthernet: ${status.isEthernet}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Wi-Fi'),
                            selected: status == NanoConnectivityStatus.wifi,
                            onSelected: (_) => _connectivity
                                .updateStatus(NanoConnectivityStatus.wifi),
                          ),
                          ChoiceChip(
                            label: const Text('Cellular (4G/5G)'),
                            selected: status == NanoConnectivityStatus.cellular,
                            onSelected: (_) => _connectivity
                                .updateStatus(NanoConnectivityStatus.cellular),
                          ),
                          ChoiceChip(
                            label: const Text('Ethernet'),
                            selected: status == NanoConnectivityStatus.ethernet,
                            onSelected: (_) => _connectivity
                                .updateStatus(NanoConnectivityStatus.ethernet),
                          ),
                          ChoiceChip(
                            label: const Text('Offline (None)'),
                            selected: status == NanoConnectivityStatus.none,
                            onSelected: (_) => _connectivity
                                .updateStatus(NanoConnectivityStatus.none),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // 2. Debounced Search Field
            Text(
              '2. Debounced Search (NanoTextField + NanoDebouncer)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            NanoTextField(
              label: 'Type rapidly to search...',
              hint: 'Debounce waits 500ms after you stop typing',
              prefixIcon: const Icon(Icons.search),
              debounceDuration: const Duration(milliseconds: 500),
              onChanged: (value) {
                setState(() => _debouncedText = value);
              },
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _debouncedText.isEmpty
                    ? 'Debounced Result: (Waiting for input...)'
                    : '🎯 Debounced Result: "$_debouncedText"',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
