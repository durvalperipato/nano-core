/// An abstract contract to deserialize JSON maps into domain entities.
abstract mixin class NanoReadAdapter<Entity> {
  /// Const constructor allowing subclasses to be const.
  const NanoReadAdapter();

  /// Converts a JSON [Map] into an instance of [Entity].
  Entity fromMap(Map<String, dynamic> map);

  /// Safely converts a dynamic [map] payload into an [Entity], or returns
  /// `null` if [map] is null.
  ///
  /// Throws an [ArgumentError] if [map] is not null and is not a [Map].
  Entity? fromMapOrNull(dynamic map) {
    if (map == null) return null;

    if (map is! Map) {
      throw ArgumentError(
        'NanoReadAdapter<$Entity>: Expected a Map<String, dynamic> or null '
        'for deserialization, but received ${map.runtimeType} ($map). '
        'Please verify if the backend schema has changed.',
      );
    }

    final normalizedMap = map is Map<String, dynamic>
        ? map
        : Map<String, dynamic>.from(map);

    return fromMap(normalizedMap);
  }

  /// Safely converts a dynamic [jsonList] into a strongly-typed `List<Entity>`.
  List<Entity> fromList(dynamic jsonList) {
    if (jsonList is! List) return const [];
    return jsonList.map(fromMapOrNull).whereType<Entity>().toList();
  }
}
