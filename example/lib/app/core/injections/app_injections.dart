import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_http_client.dart';

/// Global application-level dependency injection configuration.
///
/// Registers core services (such as [NanoHttpClient]) available application-wide.
class AppInjections extends NanoInjections {
  /// Creates a new [AppInjections] instance for the root scope.
  AppInjections() : super(scope: 'global');

  @override
  void binds(GetIt i) {
    // Register the HTTP client implementation once at app startup
    i.registerLazySingleton<NanoHttpClient>(() => const MockHttpClient());
  }
}
