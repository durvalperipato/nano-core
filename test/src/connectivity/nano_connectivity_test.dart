import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoConnectivityStatus', () {
    test('online status getters return expected boolean values', () {
      expect(NanoConnectivityStatus.wifi.isOnline, isTrue);
      expect(NanoConnectivityStatus.wifi.isOffline, isFalse);
      expect(NanoConnectivityStatus.wifi.isWifi, isTrue);
      expect(NanoConnectivityStatus.wifi.isCellular, isFalse);

      expect(NanoConnectivityStatus.cellular.isOnline, isTrue);
      expect(NanoConnectivityStatus.cellular.isCellular, isTrue);

      expect(NanoConnectivityStatus.ethernet.isOnline, isTrue);
      expect(NanoConnectivityStatus.ethernet.isEthernet, isTrue);

      expect(NanoConnectivityStatus.bluetooth.isOnline, isTrue);
      expect(NanoConnectivityStatus.bluetooth.isBluetooth, isTrue);

      expect(NanoConnectivityStatus.vpn.isOnline, isTrue);
      expect(NanoConnectivityStatus.vpn.isVpn, isTrue);

      expect(NanoConnectivityStatus.none.isOnline, isFalse);
      expect(NanoConnectivityStatus.none.isOffline, isTrue);

      expect(NanoConnectivityStatus.unknown.isOnline, isFalse);
      expect(NanoConnectivityStatus.unknown.isOffline, isFalse);
    });
  });

  group('NanoConnectivity', () {
    test('initializes with default or custom status', () {
      final connectivity = NanoConnectivity();
      expect(connectivity.status, NanoConnectivityStatus.wifi);
      expect(connectivity.isOnline, isTrue);
      expect(connectivity.isOffline, isFalse);
      connectivity.dispose();

      final offlineConn = NanoConnectivity(
        initialStatus: NanoConnectivityStatus.none,
      );
      expect(offlineConn.status, NanoConnectivityStatus.none);
      expect(offlineConn.isOffline, isTrue);
      offlineConn.dispose();
    });

    test('updateStatus notifies listeners and emits on stream', () async {
      final connectivity = NanoConnectivity();
      final emittedStatuses = <NanoConnectivityStatus>[];

      final sub = connectivity.onStatusChanged.listen(emittedStatuses.add);

      var notificationCount = 0;
      connectivity
        ..addListener(() => notificationCount++)
        ..updateStatus(NanoConnectivityStatus.none);
      expect(connectivity.status, NanoConnectivityStatus.none);
      expect(connectivity.isOffline, isTrue);
      expect(notificationCount, 1);

      // Updating with same status should be no-op
      connectivity.updateStatus(NanoConnectivityStatus.none);
      expect(notificationCount, 1);

      connectivity.updateStatus(NanoConnectivityStatus.cellular);
      expect(connectivity.status, NanoConnectivityStatus.cellular);
      expect(notificationCount, 2);

      await Future<void>.delayed(Duration.zero);
      expect(emittedStatuses, [
        NanoConnectivityStatus.none,
        NanoConnectivityStatus.cellular,
      ]);

      await sub.cancel();
      connectivity.dispose();
    });
  });
}
