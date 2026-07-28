import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  runApp(const NanoCoreExampleApp());
}

/// Main entry widget for the Nano Core showcase application.
class NanoCoreExampleApp extends StatelessWidget {
  const NanoCoreExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nano Core Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
          error: Color(0xFFEF4444),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF334155), width: 1),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const ShowcasePage(),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. Dependency Injection Scope
// -----------------------------------------------------------------------------

/// Dependency injection bindings for the showcase page.
class ShowcaseInjections extends NanoInjections {
  ShowcaseInjections() : super(scope: 'showcase');

  @override
  void binds(GetIt i) {
    if (!i.isRegistered<ShowcaseController>()) {
      i.registerFactory<ShowcaseController>(() => ShowcaseController());
    }
  }
}

// -----------------------------------------------------------------------------
// 2. Controller Layer
// -----------------------------------------------------------------------------

/// Controller managing state, commands, and mock async operations.
class ShowcaseController extends NanoController<String> {
  /// Command for triggering reactive background tasks.
  late final NanoCommand0<String> fetchUserCommand;

  ShowcaseController() {
    fetchUserCommand = NanoCommand0<String>(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'User profile fetched successfully!';
    });
  }

  /// Simulates an async operation returning success.
  Future<void> simulateSuccess() async {
    execute(() async {
      await Future.delayed(const Duration(milliseconds: 1500));
      return 'Dashboard analytics updated successfully!';
    });
  }

  /// Simulates an async operation returning a warning state.
  Future<void> simulateWarning() async {
    emit(state.toLoading());
    await Future.delayed(const Duration(milliseconds: 1200));
    emit(state.toWarning('API rate limit reached (80%). Slowing down...'));
  }

  /// Simulates an async operation returning an error.
  Future<void> simulateError() async {
    execute(() async {
      await Future.delayed(const Duration(milliseconds: 1200));
      throw Exception('Failed to connect to backend server. (HTTP 500)');
    });
  }

  /// Resets controller state to initial.
  void resetState() {
    emit(const NanoState<String>());
  }
}

// -----------------------------------------------------------------------------
// 3. View Layer (Integrating NanoStatePage)
// -----------------------------------------------------------------------------

/// Showcase Page demonstrating Nano Core architecture and design system.
class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState
    extends
        NanoStatePage<ShowcasePage, ShowcaseController, ShowcaseInjections> {
  @override
  ShowcaseInjections get injections => ShowcaseInjections();

  @override
  Widget build(BuildContext context) {
    return NanoScaffold(
      controller: controller,
      header: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Color(0xFF6366F1)),
            ),
            const SizedBox(width: 12),
            const Text('Nano Core Studio'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset State',
            onPressed: controller.resetState,
          ),
        ],
      ),
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDeviceEnvironmentCard(context),
              const SizedBox(height: 20),
              _buildStateSimulatorCard(context),
              const SizedBox(height: 20),
              _buildToastShowcaseCard(context),
              const SizedBox(height: 20),
              _buildNanoCommandCard(context),
            ],
          ),
        );
      },
    );
  }

  /// Card displaying live device detection capabilities.
  Widget _buildDeviceEnvironmentCard(BuildContext context) {
    final isDesktop = NanoDeviceType.isDesktop(context);
    final isMobile = NanoDeviceType.isMobile(context);
    final deviceType = NanoDeviceType.fromContext(context);
    final width = MediaQuery.of(context).size.width.toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
              icon: Icons.devices,
              title: 'NanoDeviceType Environment Detection',
              subtitle: 'Real-time screen and platform environment inspection',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatusBadge(
                  label: 'Desktop Layout',
                  isActive: isDesktop,
                  color: const Color(0xFF6366F1),
                ),
                _StatusBadge(
                  label: 'Mobile Layout',
                  isActive: isMobile,
                  color: const Color(0xFFF59E0B),
                ),
                _StatusBadge(
                  label: 'Active: ${deviceType.name.toUpperCase()}',
                  isActive: true,
                  color: const Color(0xFF10B981),
                ),
                _StatusBadge(
                  label: 'Width: ${width}px',
                  isActive: true,
                  color: const Color(0xFF38BDF8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Card demonstrating reactive state simulation.
  Widget _buildStateSimulatorCard(BuildContext context) {
    final state = controller.state;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
              icon: Icons.alt_route,
              title: 'Reactive State Machine (NanoState)',
              subtitle:
                  'Trigger state updates observed automatically by NanoScaffold',
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
                  _getStateIcon(state),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Status: ${state.status.name.toUpperCase()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getStateColor(state),
                          ),
                        ),
                        if (state.data != null)
                          Text(
                            state.data!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        if (state.warning != null)
                          Text(
                            state.warning!,
                            style: TextStyle(color: _getStateColor(state)),
                          ),
                        if (state.error != null)
                          Text(
                            state.error!,
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Card demonstrating multiplatform NanoToast notifications.
  Widget _buildToastShowcaseCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
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

  /// Card demonstrating NanoCommand and NanoCommandBuilder.
  Widget _buildNanoCommandCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
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

  Widget _getStateIcon(NanoState state) {
    if (state.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }
    if (state.isSuccess) {
      return const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28);
    }
    if (state.isWarning) {
      return const Icon(Icons.warning, color: Color(0xFFF59E0B), size: 28);
    }
    if (state.isError) {
      return const Icon(Icons.error, color: Color(0xFFEF4444), size: 28);
    }
    return const Icon(Icons.info_outline, color: Colors.blueAccent, size: 28);
  }

  Color _getStateColor(NanoState state) {
    if (state.isSuccess) return const Color(0xFF10B981);
    if (state.isWarning) return const Color(0xFFF59E0B);
    if (state.isError) return const Color(0xFFEF4444);
    return Colors.white70;
  }
}

// -----------------------------------------------------------------------------
// Helper UI Components
// -----------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6366F1), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.isActive,
    required this.color,
  });

  final String label;
  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.15) : Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.4) : Colors.white24,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
