/// Contract defining an observer for application telemetry and analytics
/// events.
///
/// Implement this interface to bridge analytics providers such as Firebase
/// Analytics, Mixpanel, Datadog, Segment, or custom analytics endpoints into
/// the `nano-core` ecosystem without external package coupling.
abstract interface class NanoAnalyticsObserver {
  /// Called when a screen view or page navigation is tracked.
  ///
  /// - [screenName]: Canonical route template or screen identifier
  ///   (e.g., `'/product/:id'`).
  /// - [parameters]: Optional contextual parameters extracted from route
  ///   arguments.
  void onScreenView(String screenName, {Map<String, dynamic>? parameters});

  /// Called when a custom domain or user interaction event is tracked.
  ///
  /// - [name]: The event name (e.g., `'checkout_completed'`).
  /// - [parameters]: Optional key-value parameters associated with the event.
  void onEvent(String name, {Map<String, dynamic>? parameters});

  /// Associates subsequent events with a specific user identifier.
  ///
  /// Passing `null` should clear the user identifier (e.g. on logout).
  void setUserId(String? id);

  /// Sets a persistent user property or trait across subsequent analytics
  /// events.
  void setUserProperty(String key, String value);
}
