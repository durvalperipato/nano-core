import '../models/nano_paths.dart';
import '../routes/nano_route_base.dart';
import 'nano_route_match.dart';

/// Compiles a declarative route path into a pattern matcher for dynamic
/// URL segments (e.g., `:id`, `*path`).
class NanoRouteMatcher {
  /// Creates a [NanoRouteMatcher] for a [pattern] and associates it with
  /// [route].
  factory NanoRouteMatcher({
    required String pattern,
    required NanoRouteBase route,
  }) {
    final paramNames = <String>[];
    final regExp = _compilePattern(pattern, paramNames);
    return NanoRouteMatcher._(
      pattern: pattern,
      route: route,
      paramNames: List.unmodifiable(paramNames),
      regExp: regExp,
    );
  }

  const NanoRouteMatcher._({
    required this.pattern,
    required this.route,
    required List<String> paramNames,
    required RegExp regExp,
  }) : _paramNames = paramNames,
       _regExp = regExp;

  static const String _pathSeparator = '/';

  /// The original route pattern (e.g., `/users/:id`).
  final String pattern;

  /// The route definition associated with this matcher.
  final NanoRouteBase route;

  final List<String> _paramNames;
  final RegExp _regExp;

  /// Checks whether a [path] contains dynamic parameter tokens (`:` or `*`).
  static bool isDynamicPattern(String path) =>
      path.contains(':') || path.contains('*');

  /// Attempts to match a requested [path] against this compiled pattern.
  ///
  /// Returns a [NanoRouteMatch] if successful, or `null` if no match.
  NanoRouteMatch? match(String path) {
    final normalized = _normalizePath(path);
    final match = _regExp.firstMatch(normalized);
    if (match == null) return null;

    final params = <String, String>{};
    for (var i = 0; i < _paramNames.length; i++) {
      final name = _paramNames[i];
      final value = match.group(i + 1);
      if (value != null) {
        params[name] = Uri.decodeComponent(value);
      }
    }

    return NanoRouteMatch(
      route: route,
      canonicalPath: pattern,
      pathParameters: params,
    );
  }

  static String _normalizePath(String path) {
    if (path.isEmpty || path == NanoPaths.root) return NanoPaths.root;
    var clean = path.trim();
    if (!clean.startsWith(_pathSeparator)) clean = '$_pathSeparator$clean';
    if (clean.length > 1 && clean.endsWith(_pathSeparator)) {
      clean = clean.substring(0, clean.length - 1);
    }
    return clean;
  }

  static RegExp _compilePattern(String pattern, List<String> paramNames) {
    final normalized = _normalizePath(pattern);
    final segments =
        normalized.split(_pathSeparator).where((s) => s.isNotEmpty).toList();
    final buffer = StringBuffer('^');

    for (final segment in segments) {
      buffer.write(_pathSeparator);
      if (segment.startsWith(':')) {
        final name = segment.substring(1);
        paramNames.add(name);
        buffer.write('([^/]+)');
      } else if (segment.startsWith('*')) {
        final name = segment.length > 1 ? segment.substring(1) : 'wildcard';
        paramNames.add(name);
        buffer.write('(.*)');
      } else {
        buffer.write(RegExp.escape(segment));
      }
    }

    buffer.write('/?\$');
    return RegExp(buffer.toString());
  }
}
