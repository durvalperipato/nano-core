/// Represents the severity level of a log entry in [NanoLogger].
enum NanoLogLevel {
  /// Verbose diagnostic information for local debugging.
  debug(1, '🔍', 'DEBUG', '\x1B[36m'),

  /// Informational operational message.
  info(2, '💡', 'INFO', '\x1B[34m'),

  /// Successful completion of an action or process.
  success(3, '✅', 'SUCCESS', '\x1B[32m'),

  /// Non-fatal warning indicating a potential issue.
  warning(4, '⚠️', 'WARNING', '\x1B[33m'),

  /// Critical error, exception, or failure.
  error(5, '❌', 'ERROR', '\x1B[31m'),

  /// Network and HTTP traffic events.
  http(6, '🌐', 'HTTP', '\x1B[35m');

  const NanoLogLevel(this.priority, this.emoji, this.label, this.ansiColor);

  /// Numeric priority used for minimum level filtering.
  final int priority;

  /// Display emoji for the level.
  final String emoji;

  /// Textual badge for the level.
  final String label;

  /// ANSI color escape code for terminal formatting.
  final String ansiColor;
}
