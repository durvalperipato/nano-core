import '../adapter/nano_adapter.dart';
import '../entity/nano_entity.dart';
import '../extensions/nano_http_response_extension.dart';
import '../http/nano_http_client.dart';

/// An abstract generic repository providing standard CRUD operations.
///
/// Combines [NanoHttpClient] and [NanoAdapter] to handle HTTP requests
/// and model serialization/deserialization for entities of type [T].
abstract class NanoRepository<T extends NanoEntity<ID>, ID> {
  /// Creates a [NanoRepository] instance.
  const NanoRepository({
    required this.client,
    required this.endpoint,
    required this.adapter,
  });

  /// The HTTP client used to perform requests.
  final NanoHttpClient client;

  /// The base endpoint URL path for this repository (e.g., `/users`).
  final String endpoint;

  /// The adapter used to serialize and deserialize [T].
  final NanoAdapter<T> adapter;

  /// Retrieves a list of all entities of type [T].
  Future<List<T>> getAll({
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await client.get<List<dynamic>>(
      endpoint,
      queryParameters: queryParameters,
      headers: headers,
    );

    final data = response.data;
    if (data == null) return <T>[];

    return data
        .map((item) => adapter.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Retrieves a single entity of type [T] by its [id].
  Future<T?> getById(
    ID id, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await client.get<Map<String, dynamic>>(
      '$endpoint/$id',
      queryParameters: queryParameters,
      headers: headers,
    );

    final data = response.data;
    if (data == null) return null;

    return adapter.fromJson(data);
  }

  /// Creates a new entity on the server.
  Future<T> create(
    T entity, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await client.post<Map<String, dynamic>>(
      endpoint,
      data: adapter.toJson(entity),
      queryParameters: queryParameters,
      headers: headers,
    );

    final data = response.data;
    if (data == null) return entity;

    return adapter.fromJson(data);
  }

  /// Updates an existing entity on the server using its `id`.
  Future<T> update(
    T entity, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await client.put<Map<String, dynamic>>(
      '$endpoint/${entity.id}',
      data: adapter.toJson(entity),
      queryParameters: queryParameters,
      headers: headers,
    );

    final data = response.data;
    if (data == null) return entity;

    return adapter.fromJson(data);
  }

  /// Deletes an entity from the server by its [id].
  Future<bool> delete(
    ID id, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await client.delete<dynamic>(
      '$endpoint/$id',
      queryParameters: queryParameters,
      headers: headers,
    );

    return response.isSuccess;
  }
}
