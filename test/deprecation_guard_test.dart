import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Deprecation Guard (CI / Automated Enforcement)', () {
    test('enforces backwards compatibility before target version', () {
      final pubspecContent = File('pubspec.yaml').readAsStringSync();
      final versionLine = pubspecContent
          .split('\n')
          .firstWhere((line) => line.trim().startsWith('version:'));
      final versionStr = versionLine.split(':')[1].trim();

      final versionParts = versionStr
          .split('+')
          .first
          .split('-')
          .first
          .split('.')
          .map(int.parse)
          .toList();
      final major = versionParts[0];
      final minor = versionParts[1];
      final patch = versionParts[2];

      final fileContent = File(
        'lib/src/extensions/nano_navigation_extension.dart',
      ).readAsStringSync();

      final isAtLeast1_2_0 =
          major > 1 ||
          (major == 1 && minor >= 2) ||
          (major == 1 && minor == 2 && patch >= 0);

      if (isAtLeast1_2_0) {
        // When version reaches 1.2.0 or above, legacy deprecated methods MUST
        // be removed.
        expect(
          fileContent.contains('void toTab<'),
          isFalse,
          reason:
              'Version $versionStr reached 1.2.0! Deprecated method "toTab" '
              'must be removed.',
        );
        expect(
          fileContent.contains('void toSubView<'),
          isFalse,
          reason:
              'Version $versionStr reached 1.2.0! '
              'Deprecated method "toSubView" must be removed.',
        );
        expect(
          fileContent.contains('void closeSubView()'),
          isFalse,
          reason:
              'Version $versionStr reached 1.2.0! '
              'Deprecated method "closeSubView" must be removed.',
        );
      } else {
        // Before 1.2.0, legacy methods MUST remain available with @Deprecated
        // to ensure ZERO breaking changes.
        expect(
          fileContent.contains('void toTab<'),
          isTrue,
          reason:
              'Backwards compatibility broken! "toTab" must be present '
              'until 1.2.0.',
        );
        expect(
          fileContent.contains('void toSubView<'),
          isTrue,
          reason:
              'Backwards compatibility broken! "toSubView" must be present '
              'until 1.2.0.',
        );
        expect(
          fileContent.contains('void closeSubView()'),
          isTrue,
          reason:
              'Backwards compatibility broken! "closeSubView" must be present '
              'until 1.2.0.',
        );
        expect(
          fileContent.contains('@Deprecated'),
          isTrue,
          reason: 'Legacy navigation methods must be marked with @Deprecated.',
        );
      }
    });
  });
}
