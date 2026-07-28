import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'showcase_controller.dart';
import 'showcase_injections.dart';
import 'widgets/device_environment_card.dart';
import 'widgets/nano_command_card.dart';
import 'widgets/state_simulator_card.dart';
import 'widgets/toast_showcase_card.dart';

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
              const DeviceEnvironmentCard(),
              const SizedBox(height: 20),
              StateSimulatorCard(controller: controller),
              const SizedBox(height: 20),
              const ToastShowcaseCard(),
              const SizedBox(height: 20),
              NanoCommandCard(controller: controller),
            ],
          ),
        );
      },
    );
  }
}
