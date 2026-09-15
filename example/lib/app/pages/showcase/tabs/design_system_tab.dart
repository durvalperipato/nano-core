import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../widgets/form_showcase_card.dart';
import '../widgets/skeleton_and_shimmer_card.dart';
import '../widgets/toast_showcase_card.dart';

/// Tab showcasing Nano Core Design System & UI components.
class DesignSystemTab extends StatelessWidget {
  /// Creates a [DesignSystemTab] widget.
  const DesignSystemTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 20,
        children: [
          const SkeletonAndShimmerCard(),
          const ToastShowcaseCard(),
          const FormShowcaseCard(),
          Center(
            child: NanoPoweredBy(
              companyName: 'NanoDevs',
              prefix: 'Showcase synced with nano_core',
              version: 'v1.0.7',
              isCompact: true,
              onTap: () {
                NanoToast.show(
                  context,
                  message: 'Nano Core Showcase: v1.0.7',
                  type: NanoToastType.success,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
