import 'package:get_it/get_it.dart';
import '../adapter/nano_adapter.dart';
import '../cache/nano_cache.dart';
import '../cache/nano_cache_policy.dart';
import '../entity/nano_entity.dart';
import '../extensions/nano_http_response_extension.dart';
import '../http/nano_http_client.dart';
import '../pagination/nano_pagination.dart';

/// An abstract generic repository providing standard CRUD operations with
/// optional caching, pagination, and type-safe query adapters.
abstract class NanoRepository<Entity extends NanoEntity<Id>, Id> {
  /// Creates a [NanoRepository] instance.
  ///
  /// If [client], [cache], or [cachePolicy] are omitted, they automatically
  /// resolve from [GetIt] when registered via [NanoDefaultInjections].
  const NanoRepository({
    required this.endpoint,
    required this.adapter,
    this.cacheTtl,
    NanoHttpClient? client,
    NanoCache? cache,
    NanoCachePolicy? cachePolicy,
  })  : _client = client,
        _cache = cache,
        _cachePolicy = cachePolicy;

  final NanoHttpClient? _client;
  final NanoCache? _cache;
  final NanoCachePolicy? _cachePolicy;

  /// The HTTP client used to perform requests.
  NanoHttpClient get client => _client ?? GetIt.I<NanoHttpClient>();

  /// The active caching store, resolved from injection or constructor.
  NanoCache? get cache =>
      _cache ??
      (GetIt.I.isRegistered<NanoCache>() ? GetIt.I<NanoCache>() : null);

  /// The default cache policy for this repository.
  NanoCachePolicy get cachePolicy =>
      _cachePolicy ??
      (GetIt.I.isRegistered<NanoCachePolicy>()
          ? GetIt.I<NanoCachePolicy>()
          : NanoCachePolicy.networkOnly);

  /// Default Time-To-Live duration for cached entries in this repository.
  final Duration? cacheTtl;

  /// The base endpoint URL path for this repository (e.g., `/users`).
  final String endpoint;

  /// Builds the endpoint URL path used for [getAll]. Defaults to [endpoint].
  String endpointGetAll() => endpoint;

  /// Builds the endpoint URL path used for [getById]. Defaults to `$endpoint/$id`.
  String endpointGetById(Id id) => '$endpoint/$id';

  /// Builds the endpoint URL path used for [create]. Defaults to [endpoint].
  String endpointCreate(Entity entity) => endpoint;

  /// Builds the endpoint URL path used for [update]. Defaults to `$endpoint/${entity.id}`.
  String endpointUpdate(Entity entity) => '$endpoint/${entity.id}';

  /// Builds the endpoint URL path used for [delete]. Defaults to `$endpoint/$id`.
  String endpointDelete(Id id) => '$endpoint/$id';

  /// The adapter used to serialize and deserialize [Entity].
  final NanoAdapter<Entity> adapter;

  /// Builds a deterministic cache key from an endpoint and query parameters.
  String _buildCacheKey(String path, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return path;
    final sortedKeys = params.keys.toList()..sort();
    final query = sortedKeys.map((k) => '$k=${params[k]}').join('&');
    return '$path?$query';
  }

  /// Invalidates (clears) cached entries for this repository or matching
  /// a prefix.
  void invalidateCache({String? prefix}) =>
      cache?.clear(prefix: prefix ?? endpoint);

  /// Retrieves a list of entities of type [Entity], optionally applying
  /// [pagination] and [cachePolicy].
  Future<List<Entity>> getAll({
    NanoPagination? pagination,
    NanoCachePolicy? cachePolicy,
    Duration? cacheTtl,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) =>
      fetchList(
        path: endpointGetAll(),
        pagination: pagination,
        cachePolicy: cachePolicy,
        cacheTtl: cacheTtl,
        queryParameters: queryParameters,
        headers: headers,
      );

  /// Fetches a list of entities from a specific [path], applying
  /// [pagination] and [cachePolicy].
  Future<List<Entity>> fetchList({
    required String path,
    NanoPagination? pagination,
    NanoCachePolicy? cachePolicy,
    Duration? cacheTtl,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final effectivePolicy = cachePolicy ?? this.cachePolicy;
    final effectiveTtl = cacheTtl ?? this.cacheTtl;
    final params = {
      ...?pagination?.toQueryParams(),
      ...?queryParameters,
    };
    final cacheKey = _buildCacheKey(
      path,
      params.isNotEmpty ? params : null,
    );

    // 1. Cache-Only:
    if (effectivePolicy == NanoCachePolicy.cacheOnly) {
      final cached = cache?.get<List<dynamic>>(cacheKey);
      if (cached == null) return <Entity>[];
      return cached
          .map((item) => adapter.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // 2. Cache-First:
    if (effectivePolicy == NanoCachePolicy.cacheFirst) {
      final cached = cache?.get<List<dynamic>>(cacheKey);
      if (cached != null) {
        return cached
            .map((item) => adapter.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }

    // 3. Network-First / Network-Only:
    try {
      final response = await client.get<List<dynamic>>(
        path,
        queryParameters: params.isNotEmpty ? params : null,
        headers: headers,
      );

      final data = response.data;
      if (data == null) return <Entity>[];

      // Save raw response to cache:
      cache?.set(cacheKey, data, ttl: effectiveTtl);

      return data
          .map((item) => adapter.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback to cache on network failure if policy is networkFirst:
      if (effectivePolicy == NanoCachePolicy.networkFirst) {
        final cached = cache?.get<List<dynamic>>(cacheKey);
        if (cached != null) {
          return cached
              .map((item) => adapter.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      rethrow;
    }
  }

  /// Retrieves a single entity of type [Entity] by its [id], optionally
  /// applying [cachePolicy].
  Future<Entity?> getById(
    Id id, {
    NanoCachePolicy? cachePolicy,
    Duration? cacheTtl,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final effectivePolicy = cachePolicy ?? this.cachePolicy;
    final effectiveTtl = cacheTtl ?? this.cacheTtl;
    final path = endpointGetById(id);
    final cacheKey = _buildCacheKey(path, queryParameters);

    if (effectivePolicy == NanoCachePolicy.cacheOnly) {
      final cached = cache?.get<Map<String, dynamic>>(cacheKey);
      if (cached == null) return null;
      return adapter.fromJson(cached);
    }

    if (effectivePolicy == NanoCachePolicy.cacheFirst) {
      final cached = cache?.get<Map<String, dynamic>>(cacheKey);
      if (cached != null) {
        return adapter.fromJson(cached);
      }
    }

    try {
      final response = await client.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        headers: headers,
      );

      final data = response.data;
      if (data == null) return null;

      cache?.set(cacheKey, data, ttl: effectiveTtl);
      return adapter.fromJson(data);
    } catch (e) {
      if (effectivePolicy == NanoCachePolicy.networkFirst) {
        final cached = cache?.get<Map<String, dynamic>>(cacheKey);
        if (cached != null) {
          return adapter.fromJson(cached);
        }
      }
      rethrow;
    }
  }

  /// Creates a new entity on the server and invalidates related cache.
  Future<Entity> create(
    Entity entity, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final path = endpointCreate(entity);
    final response = await client.post<Map<String, dynamic>>(
      path,
      data: adapter.toJson(entity),
      queryParameters: queryParameters,
      headers: headers,
    );

    invalidateCache();

    final data = response.data;
    if (data == null) return entity;

    return adapter.fromJson(data);
  }

  /// Updates an existing entity on the server and invalidates related cache.
  Future<Entity> update(
    Entity entity, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final path = endpointUpdate(entity);
    final response = await client.put<Map<String, dynamic>>(
      path,
      data: adapter.toJson(entity),
      queryParameters: queryParameters,
      headers: headers,
    );

    invalidateCache();

    final data = response.data;
    if (data == null) return entity;

    return adapter.fromJson(data);
  }

  /// Deletes an entity from the server by its [id] and invalidates
  /// related cache.
  Future<bool> delete(
    Id id, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final path = endpointDelete(id);
    final response = await client.delete<dynamic>(
      path,
      queryParameters: queryParameters,
      headers: headers,
    );

    if (response.isSuccess) {
      invalidateCache();
    }

    return response.isSuccess;
  }
}
