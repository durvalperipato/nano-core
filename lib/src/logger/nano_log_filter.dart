import 'nano_log_level.dart';

/// Defines which [NanoLogLevel] entries are allowed to be emitted by
/// [NanoLogger].
///
/// Encapsulates a set of allowed levels and provides convenient factory
/// constructors for common filtering presets.
final class NanoLogFilter {
  /// Creates a custom filter with explicit allowed [levels].
  const NanoLogFilter(this.levels);

  /// Allows all log levels (debug, info, success, warning, error, http).
  const NanoLogFilter.all()
    : levels = const {
        NanoLogLevel.debug,
        NanoLogLevel.info,
        NanoLogLevel.success,
        NanoLogLevel.warning,
        NanoLogLevel.error,
        NanoLogLevel.http,
      };

  /// Disables all log levels (completely muted).
  const NanoLogFilter.none() : levels = const {};

  /// Allows only [NanoLogLevel.error].
  const NanoLogFilter.onlyErrors() : levels = const {NanoLogLevel.error};

  /// Allows only [NanoLogLevel.warning] and [NanoLogLevel.error].
  const NanoLogFilter.errorsAndWarnings()
    : levels = const {NanoLogLevel.warning, NanoLogLevel.error};

  /// Allows only [NanoLogLevel.http] traffic logs.
  const NanoLogFilter.onlyHttp() : levels = const {NanoLogLevel.http};

  /// Creates a custom filter from a list of allowed [levels].
  factory NanoLogFilter.only(List<NanoLogLevel> levels) =>
      NanoLogFilter(levels.toSet());

  /// The set of active/allowed log levels.
  final Set<NanoLogLevel> levels;

  /// Returns true if [level] is allowed by this filter.
  bool shouldLog(NanoLogLevel level) => levels.contains(level);
}
