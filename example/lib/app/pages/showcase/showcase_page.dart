import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'enums/showcase_sub_view.dart';
import 'enums/showcase_tab.dart';
import 'showcase_controller.dart';
import 'showcase_injections.dart';
import 'tabs/data_network_tab.dart';
import 'tabs/design_system_tab.dart';
import 'tabs/navigation_diagnostics_tab.dart';
import 'tabs/state_architecture_tab.dart';
import 'widgets/showcase_info_sub_view.dart';

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
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final state = controller.state;

        return Stack(
          children: [
            NanoShellScaffold<ShowcaseTab, ShowcaseSubView>(
              initialTab: ShowcaseTab.designSystem,
              header: (context, shell) {
                final title = switch (shell.currentTab) {
                  ShowcaseTab.designSystem => '🎨 UI & Design System',
                  ShowcaseTab.stateArchitecture => '⚡ Architecture & State',
                  ShowcaseTab.dataNetwork => '🌐 Data & Network',
                  ShowcaseTab.navigationDiagnostics =>
                    '🧭 Navigation & Diagnostics',
                  null => 'Nano Core Studio',
                };

                return AppBar(
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
                      Expanded(
                        child: Text(
                          shell.isShowingSubView ? 'Showcase Info' : title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        shell.isShowingSubView
                            ? Icons.close
                            : Icons.info_outline,
                      ),
                      tooltip: shell.isShowingSubView
                          ? 'Close Info'
                          : 'Showcase Overview',
                      onPressed: () {
                        if (shell.isShowingSubView) {
                          shell.closeSubView();
                        } else {
                          shell.openSubView(ShowcaseSubView.info);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Reset State',
                      onPressed: controller.resetState,
                    ),
                  ],
                );
              },
              bottomNavigationBar: (context, shell) {
                final currentIndex = shell.currentTab?.index ?? 0;

                return NavigationBar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) {
                    shell.selectTab(ShowcaseTab.values[index]);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.palette_outlined),
                      selectedIcon: Icon(Icons.palette),
                      label: 'UI',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bolt_outlined),
                      selectedIcon: Icon(Icons.bolt),
                      label: 'State',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.cloud_outlined),
                      selectedIcon: Icon(Icons.cloud),
                      label: 'Data',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.explore_outlined),
                      selectedIcon: Icon(Icons.explore),
                      label: 'Navigation',
                    ),
                  ],
                );
              },
              tabs: [
                NanoShellTab(
                  value: ShowcaseTab.designSystem,
                  builder: (context) => const DesignSystemTab(),
                ),
                NanoShellTab(
                  value: ShowcaseTab.stateArchitecture,
                  builder: (context) => StateArchitectureTab(
                    controller: controller,
                  ),
                ),
                NanoShellTab(
                  value: ShowcaseTab.dataNetwork,
                  builder: (context) => const DataNetworkTab(),
                ),
                NanoShellTab(
                  value: ShowcaseTab.navigationDiagnostics,
                  builder: (context) => const NavigationDiagnosticsTab(),
                ),
              ],
              subViews: [
                NanoShellSubView(
                  id: ShowcaseSubView.info,
                  builder: (context) => const ShowcaseInfoSubView(),
                ),
              ],
            ),
            if (state is LoadingState) const NanoLoadingOverlay(),
          ],
        );
      },
    );
  }
}
