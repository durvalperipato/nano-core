import 'package:flutter/services.dart';

/// Lightweight utility to resolve application metadata at runtime
/// without third-party dependencies.
class NanoAppInfo {
  NanoAppInfo._();

  static const MethodChannel _channel = MethodChannel('nano_core/app_info');
  static String? _cachedVersion;

  /// Resolves the application version (e.g. 'v1.0.0') natively from the
  /// host platform (Android `PackageManager` / iOS `Bundle`), with fallback
  /// to `pubspec.yaml` asset when run in environments without the plugin.
  static Future<String?> getVersion({
    String assetPath = 'pubspec.yaml',
    bool prefixV = true,
  }) async {
    if (_cachedVersion != null) return _cachedVersion;

    // 1. Try native platform resolution via NanoCorePlugin
    try {
      final nativeVersion =
          await _channel.invokeMethod<String>('getAppVersion');
      if (nativeVersion != null && nativeVersion.trim().isNotEmpty) {
        final rawVersion = nativeVersion.trim();
        _cachedVersion = prefixV && !rawVersion.startsWith('v')
            ? 'v$rawVersion'
            : rawVersion;
        return _cachedVersion;
      }
    } catch (_) {
      // Platform channel unavailable or unhandled, proceed to fallback
    }

    // 2. Fallback to pubspec.yaml asset if declared
    try {
      final yamlContent = await rootBundle.loadString(assetPath);
      final versionMatch = RegExp(
        r'^version:\s*([^\s+]+)',
        multiLine: true,
      ).firstMatch(yamlContent);

      if (versionMatch != null && versionMatch.groupCount >= 1) {
        final rawVersion = versionMatch.group(1)!.trim();
        _cachedVersion = prefixV && !rawVersion.startsWith('v')
            ? 'v$rawVersion'
            : rawVersion;
        return _cachedVersion;
      }
    } catch (_) {
      // Fallback silently if asset is not present or configured
    }

    return null;
  }

  /// Synchronously returns the cached version if already loaded, or null.
  static String? get cachedVersion => _cachedVersion;

  /// Manually set or override the cached version.
  static void setVersion(String? version) => _cachedVersion = version;

  /// Clears in-memory cached version (useful for tests).
  static void reset() => _cachedVersion = null;
}
