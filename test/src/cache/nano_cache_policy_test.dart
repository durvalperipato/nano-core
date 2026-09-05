import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoCachePolicy', () {
    test('contains all expected cache policies', () {
      expect(NanoCachePolicy.values, contains(NanoCachePolicy.networkOnly));
      expect(NanoCachePolicy.values, contains(NanoCachePolicy.cacheFirst));
      expect(NanoCachePolicy.values, contains(NanoCachePolicy.networkFirst));
      expect(NanoCachePolicy.values, contains(NanoCachePolicy.cacheOnly));
    });
  });
}
