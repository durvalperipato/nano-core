/// Contract defining an observer for crash reporting, fatal errors, and
/// diagnostics breadcrumbs.
///
/// Implement this interface to bridge error tracking services like Firebase
/// Crashlytics, Sentry, Datadog, or custom bug monitoring backends into
/// `nano-core` without external dependencies.
abstract interface class NanoCrashObserver {
  /// Records an uncaught or deliberately captured error with its stack trace.
  ///
  /// - [error]: The caught exception or error object.
  /// - [stackTrace]: Optional stack trace associated with [error].
  /// - [reason]: Optional human-readable explanation or context.
  /// - [fatal]: Whether this error caused or is considered a fatal application
  ///   crash.
  void recordError(
    dynamic error,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  });

  /// Records a lightweight diagnostic breadcrumb message leading up to
  /// potential errors.
  void log(String message);

  /// Sets a custom key-value pair to provide diagnostic context for upcoming
  /// crash reports.
  void setCustomKey(String key, Object value);

  /// Associates subsequent crash reports with a specific user identifier.
  ///
  /// Passing `null` should clear the user identifier (e.g. on logout).
  void setUserId(String? id);
}
