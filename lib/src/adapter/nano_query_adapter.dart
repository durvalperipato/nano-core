/// An abstract contract to serialize typed query or filter models into
/// URL query parameters.
///
/// Implement this adapter to convert strongly-typed query models [Q] into
/// a [Map<String, dynamic>] suitable for HTTP GET query strings.
abstract class NanoQueryAdapter<Q> {
  /// Const constructor allowing subclasses to be const.
  const NanoQueryAdapter();

  /// Converts a typed query model [Q] into URL query parameters.
  Map<String, dynamic> toQueryParams(Q query);
}
