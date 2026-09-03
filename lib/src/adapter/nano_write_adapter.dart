/// An abstract contract to serialize domain entities into JSON maps.
abstract mixin class NanoWriteAdapter<Entity> {
  /// Const constructor allowing subclasses to be const.
  const NanoWriteAdapter();

  /// Converts an instance of [Entity] into a JSON [Map].
  Map<String, dynamic> toMap(Entity entity);

  /// Converts a [list] of entities into a `List<Map<String, dynamic>>`.
  ///
  /// Returns an empty list if [list] is null.
  List<Map<String, dynamic>> toList(List<Entity>? list) {
    if (list == null) return const [];
    return list.map(toMap).toList();
  }
}
