import 'package:flutter/material.dart';
import '../showcase_controller.dart';
import '../widgets/nano_command_card.dart';
import '../widgets/result_showcase_card.dart';
import '../widgets/state_simulator_card.dart';

/// Tab showcasing Nano Core Reactive State Management, Commands & Results.
class StateArchitectureTab extends StatelessWidget {
  /// Controller managing state simulations and commands.
  final ShowcaseController controller;

  /// Creates a [StateArchitectureTab] widget.
  const StateArchitectureTab({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 20,
        children: [
          StateSimulatorCard(controller: controller),
          NanoCommandCard(controller: controller),
          const ResultShowcaseCard(),
        ],
      ),
    );
  }
}
