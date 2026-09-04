import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'nano_log_entry.dart';
import 'nano_log_filter.dart';
import 'nano_log_level.dart';

/// Central structured logger for the nano-core ecosystem.
///
/// Formats and outputs structured, color-coded, and tagged log records
/// with support for method tracking, data payloads, and error hooks.
abstract final class NanoLogger {
  /// Global master switch for logging. Defaults to [kDebugMode].
  static bool enabled = kDebugMode;

  /// Active log filter determining which levels are emitted.
  static NanoLogFilter filter = const NanoLogFilter.all();

  /// Whether to include timestamps in the formatted output.
  static bool showTimestamp = true;

  /// Whether to render ANSI colors in terminal outputs.
  static bool showColors = true;

  /// Maximum number of stack trace frames to render in console logs.
  static int maxStackTraceLines = 10;

  /// Optional custom printer callback overriding default console output.
  static void Function(String formattedMessage)? customPrinter;

  /// Optional telemetry hook invoked whenever an error or warning is logged.
  ///
  /// Useful for streaming exceptions to Sentry, Firebase Crashlytics,
  /// or Datadog.
  static void Function(NanoLogEntry entry)? onError;

  /// Initializes and configures global [NanoLogger] settings in a single call.
  ///
  /// - [filter]: Granular filter selecting which [NanoLogLevel] entries
  ///   are emitted.
  /// - [enabled]: Master switch to enable or disable all logs.
  ///   Defaults to [kDebugMode].
  /// - [showTimestamp]: Whether to append timestamp to console outputs.
  /// - [showColors]: Whether to render ANSI colors in terminal outputs.
  /// - [maxStackTraceLines]: Maximum stack trace frames to render on errors.
  ///   Defaults to 10.
  /// - [customPrinter]: Optional custom printer callback overriding default
  ///   console output.
  /// - [onError]: Telemetry hook for warnings and errors (e.g., Sentry,
  ///   Firebase Crashlytics).
  static void init({
    NanoLogFilter? filter,
    bool? enabled,
    bool? showTimestamp,
    bool? showColors,
    int? maxStackTraceLines,
    void Function(String formattedMessage)? customPrinter,
    void Function(NanoLogEntry entry)? onError,
  }) {
    if (filter != null) NanoLogger.filter = filter;
    if (enabled != null) NanoLogger.enabled = enabled;
    if (showTimestamp != null) NanoLogger.showTimestamp = showTimestamp;
    if (showColors != null) NanoLogger.showColors = showColors;
    if (maxStackTraceLines != null) {
      NanoLogger.maxStackTraceLines = maxStackTraceLines;
    }
    if (customPrinter != null) NanoLogger.customPrinter = customPrinter;
    if (onError != null) NanoLogger.onError = onError;
  }

  /// Sets the active [NanoLogFilter].
  static void setFilter(NanoLogFilter newFilter) => filter = newFilter;

  /// Enables all logging outputs.
  static void enable() => enabled = true;

  /// Disables all logging outputs.
  static void disable() => enabled = false;

  /// Mutes logging (alias for [disable]).
  static void mute() => disable();

  /// Unmutes logging (alias for [enable]).
  static void unmute() => enable();

  /// Resets all [NanoLogger] configurations back to their default values.
  static void reset() {
    enabled = kDebugMode;
    filter = const NanoLogFilter.all();
    showTimestamp = true;
    showColors = true;
    maxStackTraceLines = 10;
    customPrinter = null;
    onError = null;
  }

  /// Logs a [NanoLogLevel.debug] diagnostic message.
  static void debug(
    String message, {
    String? tag,
    String? method,
    Object? data,
  }) {
    _log(
      NanoLogEntry(
        level: NanoLogLevel.debug,
        message: message,
        tag: tag,
        method: method,
        data: data,
      ),
    );
  }

  /// Logs a [NanoLogLevel.info] operational message.
  static void info(
    String message, {
    String? tag,
    String? method,
    Object? data,
  }) {
    _log(
      NanoLogEntry(
        level: NanoLogLevel.info,
        message: message,
        tag: tag,
        method: method,
        data: data,
      ),
    );
  }

  /// Logs a [NanoLogLevel.success] completion message.
  static void success(
    String message, {
    String? tag,
    String? method,
    Object? data,
  }) {
    _log(
      NanoLogEntry(
        level: NanoLogLevel.success,
        message: message,
        tag: tag,
        method: method,
        data: data,
      ),
    );
  }

  /// Logs a [NanoLogLevel.warning] non-fatal alert.
  static void warning(
    String message, {
    String? tag,
    String? method,
    Object? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      NanoLogEntry(
        level: NanoLogLevel.warning,
        message: message,
        tag: tag,
        method: method,
        data: data,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  /// Logs a [NanoLogLevel.error] failure or exception.
  static void error(
    String message, {
    String? httpMethod,
    int? statusCode,
    String? tag,
    String? method,
    Object? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      NanoLogEntry(
        level: NanoLogLevel.error,
        message: message,
        httpMethod: httpMethod,
        statusCode: statusCode,
        tag: tag,
        method: method,
        data: data,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  /// Logs a [NanoLogLevel.http] network event.
  static void http(
    String message, {
    String? httpMethod,
    int? statusCode,
    String? tag,
    String? method,
    Object? data,
    Object? error,
  }) {
    _log(
      NanoLogEntry(
        level: NanoLogLevel.http,
        message: message,
        httpMethod: httpMethod,
        statusCode: statusCode,
        tag: tag,
        method: method,
        data: data,
        error: error,
      ),
    );
  }

  static void _log(NanoLogEntry entry) {
    if (!enabled || !filter.shouldLog(entry.level)) return;

    if (entry.level == NanoLogLevel.error ||
        entry.level == NanoLogLevel.warning) {
      onError?.call(entry);
    }

    final formatted = format(entry);

    if (customPrinter != null) {
      customPrinter!(formatted);
      return;
    }

    developer.log(formatted, name: entry.tag ?? 'NanoCore');
  }

  /// Formats a [NanoLogEntry] into a structured, readable string.
  static String format(NanoLogEntry entry) {
    final resetColor = showColors ? '\x1B[0m' : '';
    final levelColor = showColors ? entry.level.ansiColor : '';

    final headerContext = entry.tag != null && entry.tag!.isNotEmpty
        ? ' [${entry.tag}]'
        : '';

    final header =
        '$levelColor┌── ${entry.level.emoji} '
        '[${entry.level.label}]$headerContext '
        '${'─' * 28}$resetColor';

    final buffer = StringBuffer()
      ..writeln()
      ..writeln(header)
      ..writeln('$levelColor│$resetColor Message: ${entry.message}');

    if (entry.httpMethod != null && entry.httpMethod!.isNotEmpty) {
      buffer.writeln(
        '$levelColor│$resetColor HTTP Method: '
        '${entry.httpMethod!.toUpperCase()}',
      );
    }

    if (entry.statusCode != null) {
      buffer.writeln(
        '$levelColor│$resetColor Status Code: ${entry.statusCode}',
      );
    }

    if (entry.method != null && entry.method!.isNotEmpty) {
      buffer.writeln('$levelColor│$resetColor Method: ${entry.method}');
    }

    if (entry.data != null) {
      buffer.writeln('$levelColor│$resetColor Data: ${entry.data}');
    }

    if (entry.error != null) {
      buffer.writeln('$levelColor│$resetColor Error: ${entry.error}');
    }

    if (entry.stackTrace != null) {
      final normalized = entry.stackTrace
          .toString()
          .replaceAll('\r\n', '\n')
          .replaceAll('\r', '\n');
      final rawLines = normalized.trim().split('\n');
      final cleanFrames = <String>[];

      for (var line in rawLines) {
        line = line.trim();
        if (line.isEmpty) continue;
        // In Web/DDC, skip redundant file-only lines (e.g. 'errors.dart:274')
        if (RegExp(r'^[a-zA-Z0-9_\-]+\.dart:\d+(:\d+)?$').hasMatch(line)) {
          continue;
        }
        // Collapse excess whitespace
        line = line.replaceAll(RegExp(r'\s{2,}'), ' ');
        cleanFrames.add(line);
      }

      final totalFrames = cleanFrames.length;
      final displayFrames = cleanFrames.take(maxStackTraceLines).toList();

      buffer.writeln('$levelColor│$resetColor StackTrace:');
      for (var i = 0; i < displayFrames.length; i++) {
        final frame = displayFrames[i];
        final prefix = frame.startsWith('#') ? '' : '#$i ';
        buffer.writeln('$levelColor│$resetColor   $prefix$frame');
      }

      if (totalFrames > maxStackTraceLines) {
        final remaining = totalFrames - maxStackTraceLines;
        buffer.writeln(
          '$levelColor│$resetColor   ... ($remaining more frames)',
        );
      }
    }

    if (showTimestamp) {
      final t = entry.timestamp;
      final timeStr =
          '${_pad(t.hour)}:${_pad(t.minute)}:${_pad(t.second)}.'
          '${_pad(t.millisecond, 3)}';
      buffer.writeln('$levelColor│$resetColor Time: $timeStr');
    }

    buffer
      ..writeln('$levelColor└${'─' * 52}$resetColor')
      ..writeln();

    return buffer.toString();
  }

  static String _pad(int value, [int width = 2]) {
    return value.toString().padLeft(width, '0');
  }
}

/// A convenient, concise alias for [NanoLogger].
typedef NanoLog = NanoLogger;

/// An ultra-concise alias for [NanoLogger].
typedef NLog = NanoLogger;
