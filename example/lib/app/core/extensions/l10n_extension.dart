import 'package:flutter/widgets.dart';
import 'package:nano_core_example/l10n/generated/app_localizations.dart';

/// Extension to facilitate access to translations generated via [AppLocalizations].
/// 
/// Instead of using `AppLocalizations.of(context)!`, you can simply use `context.l10n`.
extension L10nExtension on BuildContext {
  /// Returns the [AppLocalizations] instance attached to this context.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
