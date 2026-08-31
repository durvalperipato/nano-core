/// An abstract contract defining pagination parameters for HTTP requests.
abstract interface class NanoPagination {
  /// Converts the pagination parameters into URL query parameters.
  Map<String, dynamic> toQueryParams();
}
