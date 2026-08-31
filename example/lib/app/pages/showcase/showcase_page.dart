import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'showcase_controller.dart';
import 'showcase_injections.dart';
import 'showcase_messages.dart';
import 'showcase_state.dart';
import 'widgets/device_environment_card.dart';
import 'widgets/form_showcase_card.dart';
import 'widgets/logger_showcase_card.dart';
import 'widgets/nano_command_card.dart';
import 'widgets/navigation_showcase_card.dart';
import 'widgets/repository_showcase_card.dart';
import 'widgets/result_showcase_card.dart';
import 'widgets/state_simulator_card.dart';
import 'widgets/toast_showcase_card.dart';
import 'widgets/universal_adapter_showcase_card.dart';

/// Showcase Page demonstrating Nano Core architecture and design system.
class ShowcasePage extends StatefulWidget {
  /// Creates a [ShowcasePage] widget.
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState
    extends NanoStatePage<ShowcasePage, ShowcaseController> {
  @override
  NanoInjections get injections => ShowcaseInjections();

  @override
  Widget build(BuildContext context) {
    return NanoScaffold<ShowcaseState, ShowcaseMessages>(
      controller: controller,
      onCustomWarning: (warning) {
        if (warning != null) {
          NanoToast.showWarning(
            context,
            'Custom Handled Warning: ${warning.message(context)}',
          );
        }
      },
      headerBuilder: (context, state) => AppBar(
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
            Text(
              state.data?.users.isNotEmpty == true
                  ? 'Nano Core Studio (${state.data!.users.length} users)'
                  : 'Nano Core Studio',
            ),
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
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DeviceEnvironmentCard(),
              const SizedBox(height: 20),
              StateSimulatorCard(controller: controller),
              const SizedBox(height: 20),
              const FormShowcaseCard(),
              const SizedBox(height: 20),
              const ToastShowcaseCard(),
              const SizedBox(height: 20),
              const NavigationShowcaseCard(),
              const SizedBox(height: 20),
              const LoggerShowcaseCard(),
              const SizedBox(height: 20),
              const UniversalAdapterShowcaseCard(),
              const SizedBox(height: 20),
              const RepositoryShowcaseCard(),
              const SizedBox(height: 20),
              const ResultShowcaseCard(),
              const SizedBox(height: 20),
              NanoCommandCard(controller: controller),
            ],
          ),
        );
      },
    );
  }
}
