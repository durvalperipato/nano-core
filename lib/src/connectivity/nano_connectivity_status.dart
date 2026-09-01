/// Enum representing the network connectivity status of the application.
///
/// Fully cross-platform compatible across Mobile, Web, and Desktop
/// environments.
enum NanoConnectivityStatus {
  /// Connected via Wi-Fi network.
  wifi,

  /// Connected via mobile cellular network (3G, 4G, 5G).
  cellular,

  /// Connected via wired Ethernet cable (common on Desktop and Web).
  ethernet,

  /// Connected via Bluetooth tethering.
  bluetooth,

  /// Connected via Virtual Private Network (VPN).
  vpn,

  /// The device is offline with no active network connectivity.
  none,

  /// The connectivity status is unknown or being determined.
  unknown;

  /// Whether the device has any active network connection.
  bool get isOnline =>
      this == wifi ||
      this == cellular ||
      this == ethernet ||
      this == bluetooth ||
      this == vpn;

  /// Whether the device is currently offline with no network connection.
  bool get isOffline => this == none;

  /// Whether the connection is Wi-Fi.
  bool get isWifi => this == wifi;

  /// Whether the connection is mobile cellular data.
  bool get isCellular => this == cellular;

  /// Whether the connection is wired Ethernet.
  bool get isEthernet => this == ethernet;

  /// Whether the connection is Bluetooth.
  bool get isBluetooth => this == bluetooth;

  /// Whether the connection is VPN.
  bool get isVpn => this == vpn;
}
