import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'package:nano_core_example/app/core/extensions/l10n_extension.dart';

/// Specific messages for the Showcase page.
/// Implements [NanoMessageKey] to be used with Error and Warning states.
enum ShowcaseMessages implements NanoMessageKey {
  warningRateLimit,
  errorBackend;

  @override
  String Function(BuildContext) get message =>
      (context) => switch (this) {
        .warningRateLimit => context.l10n.warningRateLimit,
        .errorBackend => context.l10n.errorBackend,
      };
}
