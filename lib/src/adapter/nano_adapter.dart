/// An abstract contract to serialize and deserialize data models.
///
/// Implement this adapter to convert between JSON maps and typed domain models.
abstract class NanoAdapter<Entity> {
  /// Const constructor allowing subclasses to be const.
  const NanoAdapter();

  /// Converts a JSON [Map] into an instance of [Entity].
  Entity fromJson(Map<String, dynamic> json);

  /// Converts an instance of [Entity] into a JSON [Map].
  Map<String, dynamic> toJson(Entity model);
}
