import 'package:get_it/get_it.dart';
import '../http/nano_http_client.dart';
import 'nano_injections.dart';

/// Convenient type alias for [NanoDefaultInjections].
typedef NanoCoreInjections = NanoDefaultInjections;

/// Default dependency injection container for framework-level services.
///
/// Registers essential framework singletons such as [NanoHttpClient]
/// into [GetIt].
class NanoDefaultInjections extends NanoInjections {
  /// Creates a [NanoDefaultInjections] scope.
  const NanoDefaultInjections({
    this.client,
    super.scope = 'nano_default_global',
  });

  /// The global [NanoHttpClient] instance to be registered.
  final NanoHttpClient? client;

  @override
  void binds(GetIt i) {
    init(i, client: client);
  }

  /// Initializes default framework dependencies directly inside an existing
  /// [binds] method receiving [GetIt] `i`.
  static void init(
    GetIt i, {
    NanoHttpClient? client,
  }) {
    if (client != null && !i.isRegistered<NanoHttpClient>()) {
      i.registerLazySingleton<NanoHttpClient>(() => client);
    }
  }

  /// Convenience static helper to register default dependencies into [GetIt.I]
  /// globally at app startup (e.g. in `main()`).
  static void register({
    NanoHttpClient? client,
  }) {
    init(GetIt.I, client: client);
  }
}
