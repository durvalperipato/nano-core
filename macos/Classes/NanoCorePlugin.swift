import FlutterMacOS
import AppKit

public class NanoCorePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "nano_core/app_info", binaryMessenger: registrar.messenger)
    let instance = NanoCorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getAppVersion":
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
      result(version)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
