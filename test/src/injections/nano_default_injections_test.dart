import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';

class MockHttpClient extends Fake implements NanoHttpClient {}

class MockPagination extends Fake implements NanoPagination {}

class MockStorage extends Fake implements NanoStorage {}

class MockCache extends Fake implements NanoCache {}

class MockConnectivity extends Fake implements NanoConnectivity {}

class MockDataStrategy extends Fake implements NanoDataStrategy {}

void main() {
  group('NanoDefaultInjections', () {
    tearDown(() async {
      await GetIt.I.reset();
    });

    test('registers provided services into GetIt instance', () async {
      final client = MockHttpClient();
      final pagination = MockPagination();
      final storage = MockStorage();
      final cache = MockCache();
      final connectivity = MockConnectivity();
      final strategy = MockDataStrategy();

      NanoDefaultInjections.register(
        client: client,
        pagination: pagination,
        storage: storage,
        cache: cache,
        connectivity: connectivity,
        dataStrategy: strategy,
      );

      expect(GetIt.I.isRegistered<NanoHttpClient>(), isTrue);
      expect(GetIt.I.isRegistered<NanoPagination>(), isTrue);
      expect(GetIt.I.isRegistered<NanoStorage>(), isTrue);
      expect(GetIt.I.isRegistered<NanoCache>(), isTrue);
      expect(GetIt.I.isRegistered<NanoConnectivity>(), isTrue);
      expect(GetIt.I.isRegistered<NanoDataStrategy>(), isTrue);
    });

    test('binds via NanoDefaultInjections instance scope', () async {
      final client = MockHttpClient();
      final injections = NanoDefaultInjections(
        client: client,
        scope: 'test_nano_defaults',
      );

      await injections.initScope();
      expect(GetIt.I.hasScope('test_nano_defaults'), isTrue);
      expect(GetIt.I.isRegistered<NanoHttpClient>(), isTrue);

      injections.dropScope();
      await Future<void>.delayed(Duration.zero);
      expect(GetIt.I.hasScope('test_nano_defaults'), isFalse);
    });
  });
}
