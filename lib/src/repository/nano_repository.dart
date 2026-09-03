import 'package:get_it/get_it.dart';

import '../adapter/nano_read_adapter.dart';
import '../adapter/nano_write_adapter.dart';
import '../cache/nano_cache.dart';
import '../cache/nano_cache_policy.dart';
import '../entity/nano_entity.dart';
import '../extensions/nano_http_response_extension.dart';
import '../http/nano_http_client.dart';
import '../pagination/nano_paginated_result.dart';
import '../pagination/nano_pagination.dart';
import '../strategy/nano_data_strategy.dart';

/// An abstract generic repository providing standard CRUD operations with
/// optional caching, pagination, and type-safe query adapters.
abstract class NanoRepository<Entity extends NanoEntity<Id>, Id> {
  /// Creates a [NanoRepository] instance.
  ///
  /// If [client], [cache], [cachePolicy], or [dataStrategy] are omitted, they
  /// automatically resolve from [GetIt] when registered via
  /// [NanoDefaultInjections].
  const NanoRepository({
    required this.endpoint,
    required this.adapter,
    this.writeAdapter,
    this.cacheTtl,
    this.dataStrategy,
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

  /// The data extraction strategy configured for this repository.
  final NanoDataStrategy? dataStrategy;

  /// The effective data strategy, falling back to DI or [NanoDataStrategy.raw].
  NanoDataStrategy get effectiveDataStrategy =>
      dataStrategy ??
      (GetIt.I.isRegistered<NanoDataStrategy>()
          ? GetIt.I<NanoDataStrategy>()
          : const NanoDataStrategy.raw());

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

  /// The adapter used to deserialize [Entity] from JSON.
  final NanoReadAdapter<Entity> adapter;

  /// The optional adapter used to serialize [Entity] to JSON.
  final NanoWriteAdapter<Entity>? writeAdapter;

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

  /// Retrieves a [NanoPaginatedResult] of type [Entity], optionally applying
  /// [pagination], [cachePolicy], and [dataStrategy].
  Future<NanoPaginatedResult<Entity>> getAll({
    NanoPagination? pagination,
    NanoCachePolicy? cachePolicy,
    Duration? cacheTtl,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    NanoDataStrategy? dataStrategy,
  }) async {
    final path = endpointGetAll();
    final effectivePolicy = cachePolicy ?? this.cachePolicy;
    final effectiveTtl = cacheTtl ?? this.cacheTtl;
    final strategy = dataStrategy ?? effectiveDataStrategy;
    final params = {
      ...?pagination?.toQueryParams(),
      ...?queryParameters,
    };
    final cacheKey = _buildCacheKey(
      path,
      params.isNotEmpty ? params : null,
    );

    NanoPaginatedResult<Entity> parseResult(
      dynamic rawPayload,
      Map<String, dynamic>? responseHeaders,
    ) {
      if (rawPayload == null) {
        return const NanoPaginatedResult(items: []);
      }
      final listPayload = strategy.extractList(rawPayload);
      final meta = strategy.extractMeta(rawPayload, responseHeaders);
      final items = adapter.fromList(listPayload);

      return NanoPaginatedResult<Entity>(
        items: items,
        totalCount: meta.totalCount,
        currentPage: meta.currentPage,
        totalPages: meta.totalPages,
        hasNext: meta.hasNext,
        nextCursor: meta.nextCursor,
        meta: meta.meta,
      );
    }

    // 1. Cache-Only:
    if (effectivePolicy == NanoCachePolicy.cacheOnly) {
      final cached = cache?.get<dynamic>(cacheKey);
      return parseResult(cached, null);
    }

    // 2. Cache-First:
    if (effectivePolicy == NanoCachePolicy.cacheFirst) {
      final cached = cache?.get<dynamic>(cacheKey);
      if (cached != null) {
        return parseResult(cached, null);
      }
    }

    // 3. Network-First / Network-Only:
    try {
      final response = await client.get<dynamic>(
        path,
        queryParameters: params.isNotEmpty ? params : null,
        headers: headers,
      );

      final data = response.data;
      if (data == null) return const NanoPaginatedResult(items: []);

      // Save raw response to cache:
      cache?.set(cacheKey, data, ttl: effectiveTtl);

      return parseResult(data, response.headers);
    } catch (e) {
      // Fallback to cache on network failure if policy is networkFirst:
      if (effectivePolicy == NanoCachePolicy.networkFirst) {
        final cached = cache?.get<dynamic>(cacheKey);
        if (cached != null) {
          return parseResult(cached, null);
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
      return adapter.fromMap(cached);
    }

    if (effectivePolicy == NanoCachePolicy.cacheFirst) {
      final cached = cache?.get<Map<String, dynamic>>(cacheKey);
      if (cached != null) {
        return adapter.fromMap(cached);
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
      return adapter.fromMap(data);
    } catch (e) {
      if (effectivePolicy == NanoCachePolicy.networkFirst) {
        final cached = cache?.get<Map<String, dynamic>>(cacheKey);
        if (cached != null) {
          return adapter.fromMap(cached);
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
    final encoder = writeAdapter ??
        (adapter is NanoWriteAdapter<Entity>
            ? (adapter as NanoWriteAdapter<Entity>)
            : null);
    if (encoder == null) {
      throw UnsupportedError(
        'Cannot create entity without a NanoWriteAdapter or NanoAdapter',
      );
    }
    final response = await client.post<Map<String, dynamic>>(
      path,
      data: encoder.toMap(entity),
      queryParameters: queryParameters,
      headers: headers,
    );

    invalidateCache();

    final data = response.data;
    if (data == null) {
      throw StateError('Server returned null response data for create $Entity');
    }

    return adapter.fromMap(data);
  }

  /// Updates an existing entity on the server and invalidates related cache.
  Future<Entity> update(
    Entity entity, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final path = endpointUpdate(entity);
    final encoder = writeAdapter ??
        (adapter is NanoWriteAdapter<Entity>
            ? (adapter as NanoWriteAdapter<Entity>)
            : null);
    if (encoder == null) {
      throw UnsupportedError(
        'Cannot update entity without a NanoWriteAdapter or NanoAdapter',
      );
    }
    final response = await client.put<Map<String, dynamic>>(
      path,
      data: encoder.toMap(entity),
      queryParameters: queryParameters,
      headers: headers,
    );

    invalidateCache();

    final data = response.data;
    if (data == null) {
      throw StateError('Server returned null response data for update $Entity');
    }

    return adapter.fromMap(data);
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
