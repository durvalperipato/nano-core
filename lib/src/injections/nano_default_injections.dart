import 'package:get_it/get_it.dart';
import '../cache/nano_cache.dart';
import '../cache/nano_cache_policy.dart';
import '../http/nano_http_client.dart';
import '../pagination/nano_pagination.dart';
import 'nano_injections.dart';

/// Convenient type alias for [NanoDefaultInjections].
typedef NanoCoreInjections = NanoDefaultInjections;

/// Default dependency injection container for framework-level services.
///
/// Registers essential framework singletons such as [NanoHttpClient],
/// [NanoPagination] strategy, and [NanoCache] into [GetIt].
class NanoDefaultInjections extends NanoInjections {
  /// Creates a [NanoDefaultInjections] scope.
  const NanoDefaultInjections({
    this.client,
    this.pagination,
    this.cache,
    this.cachePolicy,
    super.scope = 'nano_default_global',
  });

  /// The global [NanoHttpClient] instance to be registered.
  final NanoHttpClient? client;

  /// The optional default global [NanoPagination] strategy.
  final NanoPagination? pagination;

  /// The optional default global [NanoCache] storage instance.
  final NanoCache? cache;

  /// The optional default global [NanoCachePolicy].
  final NanoCachePolicy? cachePolicy;

  @override
  void binds(GetIt i) {
    init(
      i,
      client: client,
      pagination: pagination,
      cache: cache,
      cachePolicy: cachePolicy,
    );
  }

  /// Initializes default framework dependencies directly inside an existing
  /// [binds] method receiving [GetIt] `i`.
  static void init(
    GetIt i, {
    NanoHttpClient? client,
    NanoPagination? pagination,
    NanoCache? cache,
    NanoCachePolicy? cachePolicy,
  }) {
    if (client != null && !i.isRegistered<NanoHttpClient>()) {
      i.registerLazySingleton<NanoHttpClient>(() => client);
    }
    if (pagination != null && !i.isRegistered<NanoPagination>()) {
      i.registerLazySingleton<NanoPagination>(() => pagination);
    }
    if (cache != null && !i.isRegistered<NanoCache>()) {
      i.registerLazySingleton<NanoCache>(() => cache);
    }
    if (cachePolicy != null && !i.isRegistered<NanoCachePolicy>()) {
      i.registerLazySingleton<NanoCachePolicy>(() => cachePolicy);
    }
  }

  /// Convenience static helper to register default dependencies into [GetIt.I]
  /// globally at app startup (e.g. in `main()`).
  static void register({
    NanoHttpClient? client,
    NanoPagination? pagination,
    NanoCache? cache,
    NanoCachePolicy? cachePolicy,
  }) {
    init(
      GetIt.I,
      client: client,
      pagination: pagination,
      cache: cache,
      cachePolicy: cachePolicy,
    );
  }
}
