import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';

class MockUserSession extends NanoEntity<String> {
  const MockUserSession({required super.id});

  @override
  List<Object?> get props => [id];
}

class FakeAuthRepository extends NanoAuthRepository<MockUserSession> {
  FakeAuthRepository({super.storage});

  bool sessionCleared = false;

  @override
  void clearSession() {
    super.clearSession();
    sessionCleared = true;
  }
}

class FakeStorage extends NanoStorage {
  final Map<String, dynamic> _map = {};

  @override
  T? get<T>(String key) => _map[key] as T?;

  @override
  void set<T>(String key, T value) => _map[key] = value;

  @override
  void delete(String key) => _map.remove(key);

  @override
  void clear({String? prefix}) => _map.clear();

  @override
  bool has(String key) => _map.containsKey(key);
}

void main() {
  group('NanoAuthInterceptor', () {
    late FakeStorage storage;
    late FakeAuthRepository authRepo;

    setUp(() {
      storage = FakeStorage();
      authRepo = FakeAuthRepository(storage: storage);
    });

    tearDown(() async {
      await GetIt.I.reset();
    });

    test('injects Bearer token into outgoing requests', () async {
      authRepo.saveToken('jwt-12345');

      final interceptor = NanoAuthInterceptor(authRepository: authRepo);

      const request = NanoHttpRequest(
        url: 'https://api.com/profile',
        method: 'GET',
      );

      final modified = await interceptor.onRequest(request);
      expect(modified.headers['Authorization'], 'Bearer jwt-12345');
    });

    test('bypasses excluded paths', () async {
      authRepo.saveToken('jwt-12345');

      final interceptor = NanoAuthInterceptor(
        authRepository: authRepo,
        excludePaths: ['/public/login'],
      );

      const request = NanoHttpRequest(
        url: 'https://api.com/public/login',
        method: 'POST',
      );

      final modified = await interceptor.onRequest(request);
      expect(modified.headers.containsKey('Authorization'), isFalse);
    });

    test('clears session and triggers onUnauthorized callback on 401 error',
        () async {
      authRepo.saveToken('jwt-12345');
      var unauthorizedCalled = false;

      final interceptor = NanoAuthInterceptor(
        authRepository: authRepo,
        onUnauthorized: () => unauthorizedCalled = true,
      );

      const error = NanoHttpError(
        message: 'Unauthorized',
        statusCode: 401,
      );

      final recovery = interceptor.onError(error);
      expect(recovery, isNull);
      expect(authRepo.sessionCleared, isTrue);
      expect(unauthorizedCalled, isTrue);
    });
  });
}
