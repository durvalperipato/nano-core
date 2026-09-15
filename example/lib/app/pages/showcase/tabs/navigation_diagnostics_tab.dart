import 'package:flutter/material.dart';
import '../widgets/device_environment_card.dart';
import '../widgets/logger_showcase_card.dart';
import '../widgets/navigation_showcase_card.dart';
import '../widgets/shell_scaffold_showcase_card.dart';

/// Tab showcasing Nano Core Navigation, Observers & Diagnostics.
class NavigationDiagnosticsTab extends StatelessWidget {
  /// Creates a [NavigationDiagnosticsTab] widget.
  const NavigationDiagnosticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 20,
        children: [
          NavigationShowcaseCard(),
          ShellScaffoldShowcaseCard(),
          LoggerShowcaseCard(),
          DeviceEnvironmentCard(),
        ],
      ),
    );
  }
}
