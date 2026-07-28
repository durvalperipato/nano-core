import 'package:flutter/material.dart';
import 'app/core/theme/app_theme.dart';
import 'app/pages/showcase/showcase_page.dart';

void main() {
  runApp(const NanoCoreExampleApp());
}

/// Main entry widget for the Nano Core showcase application.
class NanoCoreExampleApp extends StatelessWidget {
  /// Creates a [NanoCoreExampleApp] widget.
  const NanoCoreExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nano Core Showcase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const ShowcasePage(),
    );
  }
}
