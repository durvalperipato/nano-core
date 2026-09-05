import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoHttpResponseExtension', () {
    test('evaluates isSuccess, isClientError and isServerError', () {
      const res200 = NanoHttpResponse(data: {'ok': true}, statusCode: 200);
      const res204 = NanoHttpResponse(data: null, statusCode: 204);
      const res404 = NanoHttpResponse(data: null, statusCode: 404);
      const res500 = NanoHttpResponse(data: null, statusCode: 500);
      const resNull = NanoHttpResponse(data: null);

      expect(res200.isSuccess, isTrue);
      expect(res204.isSuccess, isTrue);
      expect(res200.isClientError, isFalse);
      expect(res200.isServerError, isFalse);

      expect(res404.isSuccess, isFalse);
      expect(res404.isClientError, isTrue);
      expect(res404.isServerError, isFalse);

      expect(res500.isSuccess, isFalse);
      expect(res500.isClientError, isFalse);
      expect(res500.isServerError, isTrue);

      expect(resNull.isSuccess, isFalse);
      expect(resNull.isClientError, isFalse);
      expect(resNull.isServerError, isFalse);
    });
  });
}
