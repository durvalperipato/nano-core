import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoLogFilter', () {
    test('all allows every log level', () {
      const filter = NanoLogFilter.all();
      for (final level in NanoLogLevel.values) {
        expect(filter.shouldLog(level), isTrue);
      }
    });

    test('none disallows every log level', () {
      const filter = NanoLogFilter.none();
      for (final level in NanoLogLevel.values) {
        expect(filter.shouldLog(level), isFalse);
      }
    });

    test('onlyErrors allows only error', () {
      const filter = NanoLogFilter.onlyErrors();
      expect(filter.shouldLog(NanoLogLevel.error), isTrue);
      expect(filter.shouldLog(NanoLogLevel.warning), isFalse);
      expect(filter.shouldLog(NanoLogLevel.info), isFalse);
      expect(filter.shouldLog(NanoLogLevel.http), isFalse);
    });

    test('errorsAndWarnings allows only warning and error', () {
      const filter = NanoLogFilter.errorsAndWarnings();
      expect(filter.shouldLog(NanoLogLevel.error), isTrue);
      expect(filter.shouldLog(NanoLogLevel.warning), isTrue);
      expect(filter.shouldLog(NanoLogLevel.info), isFalse);
      expect(filter.shouldLog(NanoLogLevel.debug), isFalse);
      expect(filter.shouldLog(NanoLogLevel.http), isFalse);
    });

    test('onlyHttp allows only http', () {
      const filter = NanoLogFilter.onlyHttp();
      expect(filter.shouldLog(NanoLogLevel.http), isTrue);
      expect(filter.shouldLog(NanoLogLevel.error), isFalse);
      expect(filter.shouldLog(NanoLogLevel.info), isFalse);
    });

    test('only allows custom level selection', () {
      final filter = NanoLogFilter.only([
        NanoLogLevel.debug,
        NanoLogLevel.http,
      ]);
      expect(filter.shouldLog(NanoLogLevel.debug), isTrue);
      expect(filter.shouldLog(NanoLogLevel.http), isTrue);
      expect(filter.shouldLog(NanoLogLevel.info), isFalse);
      expect(filter.shouldLog(NanoLogLevel.error), isFalse);
    });
  });

  group('NanoLogger', () {
    tearDown(NanoLogger.reset);

    test('init updates configuration values and filter', () {
      NanoLogger.init(
        enabled: false,
        filter: const NanoLogFilter.onlyErrors(),
        showColors: false,
        showTimestamp: false,
        maxStackTraceLines: 5,
      );

      expect(NanoLogger.enabled, isFalse);
      expect(NanoLogger.filter.levels, equals({NanoLogLevel.error}));
      expect(NanoLogger.showColors, isFalse);
      expect(NanoLogger.showTimestamp, isFalse);
      expect(NanoLogger.maxStackTraceLines, equals(5));
    });

    test('enable and disable controls enabled flag', () {
      NanoLogger.disable();
      expect(NanoLogger.enabled, isFalse);

      NanoLogger.enable();
      expect(NanoLogger.enabled, isTrue);

      NanoLogger.mute();
      expect(NanoLogger.enabled, isFalse);

      NanoLogger.unmute();
      expect(NanoLogger.enabled, isTrue);
    });

    test('setFilter changes the active log filter', () {
      NanoLogger.setFilter(const NanoLogFilter.onlyHttp());
      expect(NanoLogger.filter.levels, equals({NanoLogLevel.http}));
    });

    test('reset restores default values', () {
      NanoLogger.init(
        enabled: false,
        filter: const NanoLogFilter.none(),
        showColors: false,
        showTimestamp: false,
        maxStackTraceLines: 3,
      );

      NanoLogger.reset();

      expect(NanoLogger.enabled, isTrue);
      expect(NanoLogger.filter.levels.length, equals(6));
      expect(NanoLogger.showColors, isTrue);
      expect(NanoLogger.showTimestamp, isTrue);
      expect(NanoLogger.maxStackTraceLines, equals(10));
    });

    test('customPrinter respects filter selection', () {
      final logs = <String>[];
      NanoLogger.init(
        enabled: true,
        filter: const NanoLogFilter.onlyHttp(),
        customPrinter: logs.add,
      );

      NanoLogger.info('Should be ignored');
      NanoLogger.error('Should also be ignored');
      NanoLogger.http('GET /test 200');

      expect(logs.length, equals(1));
      expect(logs.first, contains('GET /test 200'));
      expect(logs.first, contains('[HTTP]'));
    });

    test('onError callback is invoked on warning and error when logged', () {
      final entries = <NanoLogEntry>[];
      NanoLogger.init(
        enabled: true,
        filter: const NanoLogFilter.errorsAndWarnings(),
        onError: entries.add,
      );

      NanoLogger.info('Info message');
      expect(entries, isEmpty);

      NanoLogger.warning('Warning message');
      expect(entries.length, equals(1));
      expect(entries.first.level, equals(NanoLogLevel.warning));

      NanoLogger.error('Error message');
      expect(entries.length, equals(2));
      expect(entries.last.level, equals(NanoLogLevel.error));
    });
  });

  group('NanoEnvironment and NanoEnv', () {
    test('getString returns defaultValue when key is absent', () {
      expect(
        NanoEnvironment.getString('NON_EXISTING', defaultValue: 'default_val'),
        equals('default_val'),
      );
    });

    test('getBool returns defaultValue when key is absent', () {
      expect(
        NanoEnvironment.getBool('NON_EXISTING', defaultValue: true),
        isTrue,
      );
      expect(NanoEnv.getBool('NON_EXISTING', defaultValue: false), isFalse);
    });

    test('getInt returns defaultValue when key is absent', () {
      expect(
        NanoEnvironment.getInt('NON_EXISTING', defaultValue: 42),
        equals(42),
      );
      expect(NanoEnv.getInt('NON_EXISTING', defaultValue: 10), equals(10));
    });

    test('getDouble returns parsed value or defaultValue', () {
      expect(
        NanoEnvironment.getDouble('NON_EXISTING', defaultValue: 3.14),
        equals(3.14),
      );
      expect(
        NanoEnv.getDouble('NON_EXISTING', defaultValue: 9.99),
        equals(9.99),
      );
    });
  });
}
