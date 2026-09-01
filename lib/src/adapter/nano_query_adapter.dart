/// An abstract contract to serialize typed query or filter models into
/// URL query parameters.
///
/// Implement this adapter to convert strongly-typed query models [Query] into
/// a [Map<String, dynamic>] suitable for HTTP GET query strings.
abstract class NanoQueryAdapter<Query> {
  /// Const constructor allowing subclasses to be const.
  const NanoQueryAdapter();

  /// Converts a typed query model [Query] into URL query parameters.
  Map<String, dynamic> toQueryParams(Query query);
}
