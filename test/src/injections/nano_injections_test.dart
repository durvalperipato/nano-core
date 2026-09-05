import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';

class ServiceA {
  final String name = 'ServiceA';
}

class SampleScopeInjections extends NanoInjections {
  const SampleScopeInjections() : super(scope: 'sample_scope');

  @override
  void binds(GetIt i) {
    i.registerLazySingleton<ServiceA>(ServiceA.new);
  }
}

class AsyncScopeInjections extends NanoInjections {
  const AsyncScopeInjections() : super(scope: 'async_scope');

  @override
  Future<void> binds(GetIt i) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    i.registerSingleton<ServiceA>(ServiceA());
  }
}

void main() {
  group('NanoInjections', () {
    tearDown(() async {
      await GetIt.I.reset();
    });

    test('initScope and dropScope manage GetIt scope lifecycle correctly',
        () async {
      const injections = SampleScopeInjections();
      expect(GetIt.I.hasScope('sample_scope'), isFalse);

      await injections.initScope();
      expect(GetIt.I.hasScope('sample_scope'), isTrue);
      expect(GetIt.I.isRegistered<ServiceA>(), isTrue);
      expect(GetIt.I<ServiceA>().name, 'ServiceA');

      injections.dropScope();
      await Future<void>.delayed(Duration.zero);
      expect(GetIt.I.hasScope('sample_scope'), isFalse);
    });

    test('call() operator invokes initScope', () async {
      const injections = SampleScopeInjections();
      expect(GetIt.I.hasScope('sample_scope'), isFalse);

      await injections();
      expect(GetIt.I.hasScope('sample_scope'), isTrue);

      injections.dropScope();
      await Future<void>.delayed(Duration.zero);
    });

    test('handles async bindings correctly', () async {
      const injections = AsyncScopeInjections();
      await injections();

      expect(GetIt.I.hasScope('async_scope'), isTrue);
      expect(GetIt.I.isRegistered<ServiceA>(), isTrue);

      injections.dropScope();
      await Future<void>.delayed(Duration.zero);
    });
  });
}
