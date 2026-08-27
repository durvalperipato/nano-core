// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get warningRateLimit =>
      'Limite de requisições da API atingido (80%). Desacelerando...';

  @override
  String get errorBackend => 'Falha ao conectar com o servidor. (HTTP 500)';
}
