/// Ergonomic extension methods on [DateTime] for universal timestamp
/// conversions and calendar calculations.
extension NanoDateTimeExtension on DateTime {
  /// Unix timestamp in seconds (standard across REST APIs, Unix, and
  /// databases).
  int get timestampSeconds => millisecondsSinceEpoch ~/ 1000;

  /// Unix timestamp in milliseconds.
  int get timestampMillis => millisecondsSinceEpoch;

  /// Returns whether this date falls on today (local time).
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns whether this date falls on yesterday (local time).
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns whether this date falls on tomorrow (local time).
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Returns whether this date is on the exact same calendar day as [other].
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Returns a new [DateTime] at the beginning of the day (00:00:00.000).
  DateTime get startOfDay => isUtc
      ? DateTime.utc(year, month, day)
      : DateTime(year, month, day);

  /// Returns a new [DateTime] at the end of the day (23:59:59.999999).
  DateTime get endOfDay => isUtc
      ? DateTime.utc(year, month, day, 23, 59, 59, 999, 999)
      : DateTime(year, month, day, 23, 59, 59, 999, 999);

  /// Returns whether this [DateTime] is strictly before the current moment.
  bool get isPast => isBefore(DateTime.now());

  /// Returns whether this [DateTime] is strictly after the current moment.
  bool get isFuture => isAfter(DateTime.now());

  /// Returns whether this [DateTime] falls inclusively between [start] and
  /// [end].
  bool isBetween(DateTime start, DateTime end) =>
      (isAfter(start) || isAtSameMomentAs(start)) &&
      (isBefore(end) || isAtSameMomentAs(end));
}
