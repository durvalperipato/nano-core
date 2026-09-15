import 'package:flutter/material.dart';
import '../widgets/connectivity_and_debounce_card.dart';
import '../widgets/repository_showcase_card.dart';
import '../widgets/universal_adapter_showcase_card.dart';

/// Tab showcasing Nano Core HTTP Client, Smart Cache & Adapters.
class DataNetworkTab extends StatelessWidget {
  /// Creates a [DataNetworkTab] widget.
  const DataNetworkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 20,
        children: [
          RepositoryShowcaseCard(),
          UniversalAdapterShowcaseCard(),
          ConnectivityAndDebounceCard(),
        ],
      ),
    );
  }
}
