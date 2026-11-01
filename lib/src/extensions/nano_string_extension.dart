/// Extension on nullable [String] for ergonomic parsing without manual checks.
extension NanoStringExtension on String? {
  /// Parses the string as an ISO-8601 [DateTime], or returns `null` if the
  /// string is null, empty, or cannot be parsed.
  DateTime? toDateTimeOrNull() {
    final value = this;
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
