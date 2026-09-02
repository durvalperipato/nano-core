import 'package:get_it/get_it.dart';
import '../cache/nano_cache.dart';
import '../cache/nano_cache_policy.dart';
import '../connectivity/nano_connectivity.dart';
import '../http/nano_http_client.dart';
import '../pagination/nano_pagination.dart';
import '../repository/nano_auth_repository.dart';
import '../storage/nano_storage.dart';
import 'nano_injections.dart';

/// Convenient type alias for [NanoDefaultInjections].
typedef NanoCoreInjections = NanoDefaultInjections;

/// Default dependency injection container for framework-level services.
///
/// Registers essential framework singletons such as [NanoHttpClient],
/// [NanoPagination] strategy, [NanoStorage], [NanoCache], [NanoConnectivity],
/// and [NanoAuthRepository] into [GetIt].
class NanoDefaultInjections extends NanoInjections {
  /// Creates a [NanoDefaultInjections] scope.
  const NanoDefaultInjections({
    this.client,
    this.pagination,
    this.storage,
    this.cache,
    this.cachePolicy,
    this.connectivity,
    this.authRepository,
    super.scope = 'nano_default_global',
  });

  /// The global [NanoHttpClient] instance to be registered.
  final NanoHttpClient? client;

  /// The optional default global [NanoPagination] strategy.
  final NanoPagination? pagination;

  /// The optional default global [NanoStorage] persistence instance.
  final NanoStorage? storage;

  /// The optional default global [NanoCache] storage instance.
  final NanoCache? cache;

  /// The optional default global [NanoCachePolicy].
  final NanoCachePolicy? cachePolicy;

  /// The optional default global [NanoConnectivity] instance.
  final NanoConnectivity? connectivity;

  /// The optional default global [NanoAuthRepository] session instance.
  final NanoAuthRepository<dynamic>? authRepository;

  @override
  void binds(GetIt i) {
    init(
      i,
      client: client,
      pagination: pagination,
      storage: storage,
      cache: cache,
      cachePolicy: cachePolicy,
      connectivity: connectivity,
      authRepository: authRepository,
    );
  }

  /// Initializes default framework dependencies directly inside an existing
  /// [binds] method receiving [GetIt] `i`.
  static void init(
    GetIt i, {
    NanoHttpClient? client,
    NanoPagination? pagination,
    NanoStorage? storage,
    NanoCache? cache,
    NanoCachePolicy? cachePolicy,
    NanoConnectivity? connectivity,
    NanoAuthRepository<dynamic>? authRepository,
  }) {
    if (client != null && !i.isRegistered<NanoHttpClient>()) {
      i.registerLazySingleton<NanoHttpClient>(() => client);
    }
    if (pagination != null && !i.isRegistered<NanoPagination>()) {
      i.registerLazySingleton<NanoPagination>(() => pagination);
    }
    if (storage != null && !i.isRegistered<NanoStorage>()) {
      i.registerLazySingleton<NanoStorage>(() => storage);
    }
    if (cache != null && !i.isRegistered<NanoCache>()) {
      i.registerLazySingleton<NanoCache>(() => cache);
    }
    if (cachePolicy != null && !i.isRegistered<NanoCachePolicy>()) {
      i.registerLazySingleton<NanoCachePolicy>(() => cachePolicy);
    }
    if (connectivity != null && !i.isRegistered<NanoConnectivity>()) {
      i.registerLazySingleton<NanoConnectivity>(() => connectivity);
    }
    if (authRepository != null &&
        !i.isRegistered<NanoAuthRepository<dynamic>>()) {
      i.registerLazySingleton<NanoAuthRepository<dynamic>>(
        () => authRepository,
      );
    }
  }

  /// Convenience static helper to register default dependencies into [GetIt.I]
  /// globally at app startup (e.g. in `main()`).
  static void register({
    NanoHttpClient? client,
    NanoPagination? pagination,
    NanoStorage? storage,
    NanoCache? cache,
    NanoCachePolicy? cachePolicy,
    NanoConnectivity? connectivity,
    NanoAuthRepository<dynamic>? authRepository,
  }) {
    init(
      GetIt.I,
      client: client,
      pagination: pagination,
      storage: storage,
      cache: cache,
      cachePolicy: cachePolicy,
      connectivity: connectivity,
      authRepository: authRepository,
    );
  }
}
