import '../equatable/nano_equatable.dart';
import 'nano_log_level.dart';

/// Represents a structured log record captured by [NanoLogger].
class NanoLogEntry extends NanoEquatable {
  /// Creates a [NanoLogEntry] instance.
  NanoLogEntry({
    required this.level,
    required this.message,
    this.httpMethod,
    this.statusCode,
    this.tag,
    this.method,
    this.data,
    this.error,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Severity level of the log entry.
  final NanoLogLevel level;

  /// Primary description or message of what occurred.
  final String message;

  /// Optional HTTP method verb (e.g. 'GET', 'POST', 'PUT', 'DELETE').
  final String? httpMethod;

  /// Optional HTTP status code associated with network entries.
  final int? statusCode;

  /// The class, service, or module emitting the log.
  final String? tag;

  /// The specific function or method name emitting the log.
  final String? method;

  /// Optional arbitrary payload or data object to inspect.
  final Object? data;

  /// Optional exception or error object.
  final Object? error;

  /// Optional stack trace associated with an error.
  final StackTrace? stackTrace;

  /// The exact moment the log entry was captured.
  final DateTime timestamp;

  @override
  List<Object?> get props => [
    level,
    message,
    httpMethod,
    statusCode,
    tag,
    method,
    data,
    error,
    timestamp,
  ];
}
