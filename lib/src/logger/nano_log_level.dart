/// Represents the severity level and category of a log entry in [NanoLogger].
enum NanoLogLevel {
  /// Verbose diagnostic information for local debugging.
  debug('🔍', 'DEBUG', '\x1B[36m'),

  /// Informational operational message.
  info('💡', 'INFO', '\x1B[34m'),

  /// Successful completion of an action or process.
  success('✅', 'SUCCESS', '\x1B[32m'),

  /// Non-fatal warning indicating a potential issue.
  warning('⚠️', 'WARNING', '\x1B[33m'),

  /// Critical error, exception, or failure.
  error('❌', 'ERROR', '\x1B[31m'),

  /// Network and HTTP traffic events.
  http('🌐', 'HTTP', '\x1B[35m');

  const NanoLogLevel(this.emoji, this.label, this.ansiColor);

  /// Display emoji for the level.
  final String emoji;

  /// Textual badge for the level.
  final String label;

  /// ANSI color escape code for terminal formatting.
  final String ansiColor;
}
