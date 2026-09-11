import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class MockAnalyticsObserver implements NanoAnalyticsObserver {
  final List<String> screens = [];
  final List<Map<String, dynamic>?> screenParameters = [];
  final List<String> events = [];
  final List<Map<String, dynamic>?> eventParameters = [];
  String? userId;
  final Map<String, String> properties = {};

  @override
  void onScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    screens.add(screenName);
    screenParameters.add(parameters);
  }

  @override
  void onEvent(String name, {Map<String, dynamic>? parameters}) {
    events.add(name);
    eventParameters.add(parameters);
  }

  @override
  void setUserId(String? id) {
    userId = id;
  }

  @override
  void setUserProperty(String key, String value) {
    properties[key] = value;
  }
}

class MockCrashObserver implements NanoCrashObserver {
  final List<dynamic> errors = [];
  final List<StackTrace?> stackTraces = [];
  final List<dynamic> reasons = [];
  final List<bool> fatalFlags = [];
  final List<String> breadcrumbs = [];
  final Map<String, Object> customKeys = {};
  String? userId;

  @override
  void recordError(
    dynamic error,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  }) {
    errors.add(error);
    stackTraces.add(stackTrace);
    reasons.add(reason);
    fatalFlags.add(fatal);
  }

  @override
  void log(String message) {
    breadcrumbs.add(message);
  }

  @override
  void setCustomKey(String key, Object value) {
    customKeys[key] = value;
  }

  @override
  void setUserId(String? id) {
    userId = id;
  }
}

class ThrowingObserver implements NanoAnalyticsObserver, NanoCrashObserver {
  @override
  void onScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    throw Exception('Crash in analytics');
  }

  @override
  void onEvent(String name, {Map<String, dynamic>? parameters}) {
    throw Exception('Crash in analytics event');
  }

  @override
  void recordError(
    dynamic error,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  }) {
    throw Exception('Crash in crash observer');
  }

  @override
  void log(String message) {
    throw Exception('Crash in log');
  }

  @override
  void setCustomKey(String key, Object value) {
    throw Exception('Crash in setCustomKey');
  }

  @override
  void setUserId(String? id) {
    throw Exception('Crash in setUserId');
  }

  @override
  void setUserProperty(String key, String value) {
    throw Exception('Crash in setUserProperty');
  }
}

void main() {
  setUp(() {
    NanoTelemetry.reset();
    NanoLogger.enabled = false;
    GetIt.I.reset();
  });

  tearDown(() {
    NanoTelemetry.reset();
    GetIt.I.reset();
  });

  group('NanoTelemetry Core & Observers', () {
    test('dispatches screen views and events to analytics observers', () {
      final obs1 = MockAnalyticsObserver();
      final obs2 = MockAnalyticsObserver();

      NanoTelemetry.init(analyticsObservers: [obs1, obs2]);

      NanoTelemetry.onScreenView('/home', parameters: {'origin': 'deeplink'});
      NanoTelemetry.onEvent('button_click', parameters: {'id': 'submit'});

      expect(obs1.screens, ['/home']);
      expect(obs1.screenParameters, [{'origin': 'deeplink'}]);
      expect(obs1.events, ['button_click']);
      expect(obs1.eventParameters, [{'id': 'submit'}]);

      expect(obs2.screens, ['/home']);
      expect(obs2.events, ['button_click']);
    });

    test('dispatches error, breadcrumbs, and custom keys to crash observers',
        () {
      final crash1 = MockCrashObserver();
      final crash2 = MockCrashObserver();

      NanoTelemetry.init(crashObservers: [crash1, crash2]);

      final error = Exception('Simulated test failure');
      final stack = StackTrace.current;

      NanoTelemetry.recordError(
        error,
        stack,
        reason: 'Payment timeout',
        fatal: true,
        debugPrint: false,
      );

      NanoTelemetry.log('Navigated to checkout');
      NanoTelemetry.setCustomKey('tier', 'premium');

      expect(crash1.errors, [error]);
      expect(crash1.stackTraces, [stack]);
      expect(crash1.reasons, ['Payment timeout']);
      expect(crash1.fatalFlags, [true]);
      expect(crash1.breadcrumbs, ['Navigated to checkout']);
      expect(crash1.customKeys, {'tier': 'premium'});

      expect(crash2.errors, [error]);
      expect(crash2.breadcrumbs, ['Navigated to checkout']);
    });

    test('synchronizes userId across both analytics and crash observers', () {
      final analytics = MockAnalyticsObserver();
      final crash = MockCrashObserver();

      NanoTelemetry.init(
        analyticsObservers: [analytics],
        crashObservers: [crash],
      );

      NanoTelemetry.setUserId('user_12345');
      expect(analytics.userId, 'user_12345');
      expect(crash.userId, 'user_12345');

      NanoTelemetry.setUserId(null);
      expect(analytics.userId, isNull);
      expect(crash.userId, isNull);
    });

    test('sets user property on analytics observers', () {
      final analytics = MockAnalyticsObserver();
      NanoTelemetry.init(analyticsObservers: [analytics]);

      NanoTelemetry.setUserProperty('plan', 'enterprise');
      expect(analytics.properties, {'plan': 'enterprise'});
    });

    test('respects master enabled switch', () {
      final analytics = MockAnalyticsObserver();
      final crash = MockCrashObserver();

      NanoTelemetry.init(
        analyticsObservers: [analytics],
        crashObservers: [crash],
        enabled: false,
      );

      NanoTelemetry.onScreenView('/home');
      NanoTelemetry.onEvent('tap');
      NanoTelemetry.recordError('err', null, debugPrint: false);
      NanoTelemetry.log('breadcrumb');

      expect(analytics.screens, isEmpty);
      expect(analytics.events, isEmpty);
      expect(crash.errors, isEmpty);
      expect(crash.breadcrumbs, isEmpty);
    });

    test('does not throw or break application if an observer fails', () {
      final throwing = ThrowingObserver();
      final normal = MockAnalyticsObserver();

      NanoTelemetry.init(analyticsObservers: [throwing, normal]);

      expect(() => NanoTelemetry.onScreenView('/test'), returnsNormally);
      expect(normal.screens, ['/test']);
    });

    test('can add and remove observers dynamically', () {
      final obs = MockAnalyticsObserver();
      final telemetry = NanoTelemetry()
        ..addAnalyticsObserver(obs)
        ..addAnalyticsObserver(obs);
      expect(telemetry.analyticsObservers.length, 1);

      telemetry.removeAnalyticsObserver(obs);
      expect(telemetry.analyticsObservers.length, 0);
    });
  });

  group('NanoDefaultInjections Telemetry Wiring', () {
    test('registers NanoTelemetry singleton when observers provided', () {
      final analytics = MockAnalyticsObserver();
      final crash = MockCrashObserver();

      NanoDefaultInjections.init(
        GetIt.I,
        analyticsObservers: [analytics],
        crashObservers: [crash],
      );

      expect(GetIt.I.isRegistered<NanoTelemetry>(), isTrue);
      final registered = GetIt.I<NanoTelemetry>();
      expect(registered.analyticsObservers, contains(analytics));
      expect(registered.crashObservers, contains(crash));
      expect(NanoTelemetry.instance, equals(registered));
    });
  });

  group('NanoRouteObserver Telemetry Integration', () {
    testWidgets('automatically tracks PageRoute screen views and breadcrumbs',
        (tester) async {
      final analytics = MockAnalyticsObserver();
      final crash = MockCrashObserver();
      NanoTelemetry.init(
        analyticsObservers: [analytics],
        crashObservers: [crash],
      );

      final observer = NanoRouteObserver();

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          initialRoute: '/',
          routes: {
            '/': (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: {'id': '42'},
                      );
                    },
                    child: const Text('Go to details'),
                  ),
                ),
            '/details': (context) => const Scaffold(body: Text('Details')),
          },
        ),
      );

      expect(analytics.screens, contains('/'));
      expect(crash.breadcrumbs, contains('Navigation: push -> /'));

      await tester.tap(find.text('Go to details'));
      await tester.pumpAndSettle();

      expect(analytics.screens, contains('/details'));
      expect(analytics.screenParameters.last, {'id': '42'});
      expect(crash.breadcrumbs, contains('Navigation: push -> /details'));
    });
  });

  group('NanoApp Global Error Handlers', () {
    test('setupGlobalErrorHandlers catches platform and framework errors', () {
      final crash = MockCrashObserver();
      NanoTelemetry.init(crashObservers: [crash]);

      NanoApp.resetGlobalErrorHandlersFlag();
      NanoApp.setupGlobalErrorHandlers();

      // Simulate Flutter framework error
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: Exception('Widget build failed'),
          stack: StackTrace.current,
          context: ErrorDescription('building MyWidget'),
        ),
      );

      expect(crash.errors, isNotEmpty);
      expect(crash.errors.first.toString(), contains('Widget build failed'));
      expect(crash.fatalFlags.first, isFalse);

      // Simulate PlatformDispatcher error
      PlatformDispatcher.instance.onError!(
        Exception('Async crash'),
        StackTrace.current,
      );

      expect(crash.errors.length, 2);
      expect(crash.errors.last.toString(), contains('Async crash'));
      expect(crash.fatalFlags.last, isTrue);
    });
  });

  group('NanoRepository Telemetry Integration', () {
    test('reports parsing errors to recordError and network errors to log',
        () async {
      final crash = MockCrashObserver();
      NanoTelemetry.init(crashObservers: [crash]);

      final repo = _TestRepo(
        client: _MockHttpClient(shouldThrowOnNetwork: true),
        adapter: _TestAdapter(),
      );

      // 1. Network error triggers breadcrumb log only
      await expectLater(
        () => repo.getById('123'),
        throwsA(isA<Exception>()),
      );

      expect(crash.breadcrumbs, isNotEmpty);
      expect(crash.breadcrumbs.first, contains('getById failed'));
      expect(crash.errors, isEmpty);

      // 2. Parsing error triggers recordError
      final parsingFailRepo = _TestRepo(
        client: _MockHttpClient(
          responseData: {'invalid': 'payload'},
        ),
        adapter: _ThrowingAdapter(),
      );

      await expectLater(
        () => parsingFailRepo.getById('456'),
        throwsA(isA<FormatException>()),
      );

      expect(crash.errors, isNotEmpty);
      expect(crash.errors.first, isA<FormatException>());
      expect(
        crash.reasons.first.toString(),
        contains('Failed to parse _TestEntity'),
      );
    });
  });
}

class _TestEntity extends NanoEntity<String> {
  const _TestEntity({required super.id});

  Map<String, dynamic> toMap() => {'id': id};
}

class _TestAdapter extends NanoAdapter<_TestEntity> {
  @override
  _TestEntity fromMap(Map<String, dynamic> map) =>
      _TestEntity(id: map['id'] as String);

  @override
  Map<String, dynamic> toMap(_TestEntity entity) => entity.toMap();
}

class _ThrowingAdapter extends NanoAdapter<_TestEntity> {
  @override
  _TestEntity fromMap(Map<String, dynamic> map) {
    throw const FormatException('Corrupted entity JSON');
  }

  @override
  Map<String, dynamic> toMap(_TestEntity entity) => entity.toMap();
}

class _TestRepo extends NanoRepository<_TestEntity, String> {
  _TestRepo({
    required super.client,
    required super.adapter,
  }) : super(endpoint: '/items');
}

class _MockHttpClient implements NanoHttpClient {
  _MockHttpClient({
    this.shouldThrowOnNetwork = false,
    this.responseData,
  });

  final bool shouldThrowOnNetwork;
  final Map<String, dynamic>? responseData;

  @override
  Future<NanoHttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    if (shouldThrowOnNetwork) {
      throw Exception('Network connection lost');
    }
    return NanoHttpResponse<T>(
      data: responseData as T?,
      statusCode: 200,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
