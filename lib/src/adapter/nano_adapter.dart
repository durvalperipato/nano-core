/// An abstract contract to serialize and deserialize data models.
///
/// Implement this adapter to convert between JSON maps and typed domain models.
abstract class NanoAdapter<T> {
  /// Const constructor allowing subclasses to be const.
  const NanoAdapter();

  /// Converts a JSON [Map] into an instance of [T].
  T fromJson(Map<String, dynamic> json);

  /// Converts an instance of [T] into a JSON [Map].
  Map<String, dynamic> toJson(T model);
}
