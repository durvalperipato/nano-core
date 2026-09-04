/// Complete modular example application demonstrating Nano Core architecture.
///
/// For the full source code structure (Controllers, Pages, Widgets), visit:
/// https://github.com/durvalperipato/nano-core/tree/main/example
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nano_core/nano_core.dart';
import 'package:nano_core_example/l10n/generated/app_localizations.dart';
import 'app/core/injections/app_injections.dart';
import 'app/core/routes/app_routes.dart';
import 'app/core/theme/app_theme.dart';

void main() {
  // Global structured logging & telemetry configuration
  NanoLogger.init(
    filter: NanoEnvironment.isDevelopment
        ? const NanoLogFilter.all()
        : const NanoLogFilter.onlyErrors(),
  );

  // Initialize global core injections (HTTP client, global services, etc.)
  AppInjections().initScope();

  runApp(const NanoCoreExampleApp());
}

/// Main entry widget for the Nano Core showcase application.
class NanoCoreExampleApp extends StatelessWidget {
  /// Creates a [NanoCoreExampleApp] widget.
  const NanoCoreExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NanoApp(
      title: 'Nano Core Showcase',
      debugShowCheckedModeBanner: false,
      router: appRouter,
      theme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('pt')],
    );
  }
}
