import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoAppInfo', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      NanoAppInfo.reset();
    });

    tearDown(() {
      NanoAppInfo.reset();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('nano_core/app_info'),
        null,
      );
    });

    test('cachedVersion returns null initially', () {
      expect(NanoAppInfo.cachedVersion, isNull);
    });

    test('setVersion updates cachedVersion', () {
      NanoAppInfo.setVersion('v2.1.0');
      expect(NanoAppInfo.cachedVersion, equals('v2.1.0'));
    });

    test('reset clears cachedVersion', () {
      NanoAppInfo.setVersion('v1.0.0');
      NanoAppInfo.reset();
      expect(NanoAppInfo.cachedVersion, isNull);
    });

    test('resolves version natively via MethodChannel', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('nano_core/app_info'),
        (MethodCall call) async {
          if (call.method == 'getAppVersion') return '3.2.1';
          return null;
        },
      );

      final version = await NanoAppInfo.getVersion();
      expect(version, equals('v3.2.1'));
      expect(NanoAppInfo.cachedVersion, equals('v3.2.1'));
    });

    test('returns null when channel fails and asset absent', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('nano_core/app_info'),
        (MethodCall call) async => throw Exception('Channel unavailable'),
      );

      final version = await NanoAppInfo.getVersion(
        assetPath: 'non_existent_pubspec.yaml',
      );
      expect(version, isNull);
    });
  });
}
