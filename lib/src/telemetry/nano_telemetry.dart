import '../logger/nano_logger.dart';
import 'observers/nano_analytics_observer.dart';
import 'observers/nano_crash_observer.dart';

/// Central facade and dispatcher for application telemetry, analytics, and
/// crash reporting.
///
/// Dispatches events transparently to multiple registered
/// [NanoAnalyticsObserver] and [NanoCrashObserver] instances without depending
/// on external SDKs.
///
/// Can be accessed via static methods or through an instantiated singleton.
class NanoTelemetry {
  /// Creates a [NanoTelemetry] instance with initial observers.
  NanoTelemetry({
    List<NanoAnalyticsObserver>? analyticsObservers,
    List<NanoCrashObserver>? crashObservers,
    this.enabled = true,
  })  : _analyticsObservers = [
          ...?analyticsObservers,
        ],
        _crashObservers = [
          ...?crashObservers,
        ];

  /// The active global [NanoTelemetry] instance.
  static NanoTelemetry instance = NanoTelemetry();

  /// Global master switch enabling or disabling telemetry dispatching.
  bool enabled;

  final List<NanoAnalyticsObserver> _analyticsObservers;
  final List<NanoCrashObserver> _crashObservers;

  /// Unmodifiable view of registered [NanoAnalyticsObserver] instances.
  List<NanoAnalyticsObserver> get analyticsObservers =>
      List.unmodifiable(_analyticsObservers);

  /// Unmodifiable view of registered [NanoCrashObserver] instances.
  List<NanoCrashObserver> get crashObservers =>
      List.unmodifiable(_crashObservers);

  /// Whether any [NanoCrashObserver] is currently registered.
  bool get hasCrashObservers => _crashObservers.isNotEmpty;

  /// Whether any [NanoAnalyticsObserver] is currently registered.
  bool get hasAnalyticsObservers => _analyticsObservers.isNotEmpty;

  /// Configures the global [NanoTelemetry] instance in a single call.
  static void init({
    List<NanoAnalyticsObserver>? analyticsObservers,
    List<NanoCrashObserver>? crashObservers,
    bool enabled = true,
  }) {
    instance = NanoTelemetry(
      analyticsObservers: analyticsObservers,
      crashObservers: crashObservers,
      enabled: enabled,
    );
  }

  /// Registers a [NanoAnalyticsObserver] to the global dispatcher.
  static void registerAnalyticsObserver(NanoAnalyticsObserver observer) {
    instance.addAnalyticsObserver(observer);
  }

  /// Registers a [NanoCrashObserver] to the global dispatcher.
  static void registerCrashObserver(NanoCrashObserver observer) {
    instance.addCrashObserver(observer);
  }

  /// Adds a [NanoAnalyticsObserver] to this dispatcher instance.
  void addAnalyticsObserver(NanoAnalyticsObserver observer) {
    if (!_analyticsObservers.contains(observer)) {
      _analyticsObservers.add(observer);
    }
  }

  /// Adds a [NanoCrashObserver] to this dispatcher instance.
  void addCrashObserver(NanoCrashObserver observer) {
    if (!_crashObservers.contains(observer)) {
      _crashObservers.add(observer);
    }
  }

  /// Removes a [NanoAnalyticsObserver] from this dispatcher instance.
  void removeAnalyticsObserver(NanoAnalyticsObserver observer) {
    _analyticsObservers.remove(observer);
  }

  /// Removes a [NanoCrashObserver] from this dispatcher instance.
  void removeCrashObserver(NanoCrashObserver observer) {
    _crashObservers.remove(observer);
  }

  /// Clears all observers from this dispatcher instance.
  void clearObservers() {
    _analyticsObservers.clear();
    _crashObservers.clear();
  }

  /// Dispatches a screen view event to all registered [analyticsObservers].
  ///
  /// - [screenName]: Canonical route template or screen identifier.
  /// - [parameters]: Optional route arguments or screen parameters.
  static void onScreenView(
    String screenName, {
    Map<String, dynamic>? parameters,
  }) {
    instance.trackScreenView(screenName, parameters: parameters);
  }

  /// Dispatches a screen view event on this instance.
  void trackScreenView(
    String screenName, {
    Map<String, dynamic>? parameters,
  }) {
    if (!enabled) return;
    for (final observer in _analyticsObservers) {
      try {
        observer.onScreenView(screenName, parameters: parameters);
      } catch (e, s) {
        NanoLogger.error(
          'Error dispatching onScreenView to ${observer.runtimeType}',
          error: e,
          stackTrace: s,
          tag: 'NanoTelemetry',
        );
      }
    }
  }

  /// Dispatches a business or interaction event to all registered
  /// [analyticsObservers].
  ///
  /// - [name]: The name of the event.
  /// - [parameters]: Optional key-value parameters.
  static void onEvent(
    String name, {
    Map<String, dynamic>? parameters,
  }) {
    instance.trackEvent(name, parameters: parameters);
  }

  /// Dispatches an event on this instance.
  void trackEvent(
    String name, {
    Map<String, dynamic>? parameters,
  }) {
    if (!enabled) return;
    for (final observer in _analyticsObservers) {
      try {
        observer.onEvent(name, parameters: parameters);
      } catch (e, s) {
        NanoLogger.error(
          'Error dispatching onEvent to ${observer.runtimeType}',
          error: e,
          stackTrace: s,
          tag: 'NanoTelemetry',
        );
      }
    }
  }

  /// Records an uncaught or captured error across all [crashObservers].
  ///
  /// If [debugPrint] is true (default), formats and prints the error locally
  /// via [NanoLogger.error] in addition to remote reporting.
  static void recordError(
    dynamic error,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
    bool debugPrint = true,
  }) {
    instance.trackError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
      debugPrint: debugPrint,
    );
  }

  /// Records an error on this instance.
  void trackError(
    dynamic error,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
    bool debugPrint = true,
  }) {
    if (debugPrint) {
      NanoLogger.error(
        reason?.toString() ?? 'Error recorded in NanoTelemetry',
        error: error,
        stackTrace: stackTrace,
        tag: 'NanoTelemetry',
      );
    }

    if (!enabled) return;

    for (final observer in _crashObservers) {
      try {
        observer.recordError(
          error,
          stackTrace,
          reason: reason,
          fatal: fatal,
        );
      } catch (e, s) {
        NanoLogger.error(
          'Error dispatching recordError to ${observer.runtimeType}',
          error: e,
          stackTrace: s,
          tag: 'NanoTelemetry',
        );
      }
    }
  }

  /// Records a lightweight diagnostic breadcrumb across all [crashObservers].
  static void log(String message) {
    instance.trackLog(message);
  }

  /// Records a breadcrumb on this instance.
  void trackLog(String message) {
    if (!enabled) return;
    for (final observer in _crashObservers) {
      try {
        observer.log(message);
      } catch (e, s) {
        NanoLogger.error(
          'Error dispatching log to ${observer.runtimeType}',
          error: e,
          stackTrace: s,
          tag: 'NanoTelemetry',
        );
      }
    }
  }

  /// Sets a custom key-value pair for upcoming crash reports across all
  /// [crashObservers].
  static void setCustomKey(String key, Object value) {
    instance.trackCustomKey(key, value);
  }

  /// Sets a custom key-value pair on this instance.
  void trackCustomKey(String key, Object value) {
    if (!enabled) return;
    for (final observer in _crashObservers) {
      try {
        observer.setCustomKey(key, value);
      } catch (e, s) {
        NanoLogger.error(
          'Error dispatching setCustomKey to ${observer.runtimeType}',
          error: e,
          stackTrace: s,
          tag: 'NanoTelemetry',
        );
      }
    }
  }

  /// Sets the user identifier across both analytics and crash observers.
  static void setUserId(String? id) {
    instance.trackUserId(id);
  }

  /// Sets the user identifier on this instance.
  void trackUserId(String? id) {
    if (!enabled) return;
    for (final observer in _analyticsObservers) {
      try {
        observer.setUserId(id);
      } catch (e, s) {
        NanoLogger.error(
          'Error setting userId on analytics observer ${observer.runtimeType}',
          error: e,
          stackTrace: s,
          tag: 'NanoTelemetry',
        );
      }
    }
    for (final observer in _crashObservers) {
      try {
        observer.setUserId(id);
      } catch (e, s) {
        NanoLogger.error(
          'Error setting userId on crash observer ${observer.runtimeType}',
          error: e,
          stackTrace: s,
          tag: 'NanoTelemetry',
        );
      }
    }
  }

  /// Sets a user property across all [analyticsObservers].
  static void setUserProperty(String key, String value) {
    instance.trackUserProperty(key, value);
  }

  /// Sets a user property on this instance.
  void trackUserProperty(String key, String value) {
    if (!enabled) return;
    for (final observer in _analyticsObservers) {
      try {
        observer.setUserProperty(key, value);
      } catch (e, s) {
        NanoLogger.error(
          'Error setting userProperty on ${observer.runtimeType}',
          error: e,
          stackTrace: s,
          tag: 'NanoTelemetry',
        );
      }
    }
  }

  /// Resets the global [NanoTelemetry] configuration back to empty defaults.
  static void reset() {
    instance = NanoTelemetry();
  }
}
