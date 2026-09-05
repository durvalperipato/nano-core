import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoHttpResponse and NanoHttpRequest', () {
    test('NanoHttpResponse holds fields and copyWith operates correctly', () {
      const original = NanoHttpResponse<String>(
        data: 'hello',
        statusCode: 200,
        statusMessage: 'OK',
        headers: {'content-type': 'application/json'},
      );

      expect(original.data, 'hello');
      expect(original.statusCode, 200);
      expect(original.statusMessage, 'OK');
      expect(original.headers?['content-type'], 'application/json');

      final copied = original.copyWith(
        data: 'world',
        statusCode: 201,
      );

      expect(copied.data, 'world');
      expect(copied.statusCode, 201);
      expect(copied.statusMessage, 'OK');
      expect(copied.headers?['content-type'], 'application/json');
    });

    test('NanoHttpRequest stores parameters properly', () {
      const request = NanoHttpRequest(
        url: 'https://api.com/users',
        method: 'POST',
        headers: {'auth': 'token'},
        queryParameters: {'page': 1},
        body: {'name': 'John'},
      );

      expect(request.url, 'https://api.com/users');
      expect(request.method, 'POST');
      expect(request.headers['auth'], 'token');
      expect(request.queryParameters['page'], 1);

      final copy = request.copyWith(url: 'https://api.com/v2/users');
      expect(copy.url, 'https://api.com/v2/users');
      expect(copy.method, 'POST');
    });
  });
}
