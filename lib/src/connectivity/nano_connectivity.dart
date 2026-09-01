import 'dart:async';
import 'package:flutter/foundation.dart';
import 'nano_connectivity_status.dart';

/// A reactive observable and contract representing application network
/// connectivity.
///
/// Implements [Listenable] and [ChangeNotifier] for easy integration with
/// Flutter widgets, routers, repositories, and dependency injection.
class NanoConnectivity extends ChangeNotifier {
  /// Creates a [NanoConnectivity] instance with an optional [initialStatus].
  NanoConnectivity({
    NanoConnectivityStatus initialStatus = NanoConnectivityStatus.wifi,
  }) : _status = initialStatus;

  NanoConnectivityStatus _status;
  final StreamController<NanoConnectivityStatus> _controller =
      StreamController<NanoConnectivityStatus>.broadcast();

  /// The current network connectivity status.
  NanoConnectivityStatus get status => _status;

  /// Whether the device is currently online.
  bool get isOnline => _status.isOnline;

  /// Whether the device is currently offline.
  bool get isOffline => _status.isOffline;

  /// A broadcast [Stream] emitting connectivity status changes.
  Stream<NanoConnectivityStatus> get onStatusChanged => _controller.stream;

  /// Updates the current connectivity status and notifies listeners.
  void updateStatus(NanoConnectivityStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    _controller.add(newStatus);
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
