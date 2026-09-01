import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class that delays invoking a callback until after a specified
/// [duration] has elapsed since the last time it was invoked.
///
/// Ideal for search query inputs, real-time filters, and preventing rapid
/// execution of expensive operations.
class NanoDebouncer {
  /// Creates a [NanoDebouncer] with the specified [duration].
  NanoDebouncer({this.duration = const Duration(milliseconds: 300)});

  /// The duration to wait before executing the callback.
  Duration duration;

  Timer? _timer;

  /// Whether a debounced action is currently scheduled and pending execution.
  bool get isPending => _timer?.isActive ?? false;

  /// Runs the given [action] after [duration] has elapsed.
  ///
  /// Cancels any previously scheduled pending action.
  void run(VoidCallback action) {
    cancel();
    _timer = Timer(duration, action);
  }

  /// Cancels any currently pending debounced action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Disposes the debouncer, cancelling any pending actions.
  void dispose() => cancel();
}
