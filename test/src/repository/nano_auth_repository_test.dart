import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

class SessionUser extends NanoEntity<String> {
  const SessionUser({required super.id, required this.email});
  final String email;

  @override
  List<Object?> get props => [id, email];
}

class TestAuthRepository extends NanoAuthRepository<SessionUser> {
  TestAuthRepository({super.storage});

  @override
  Future<SessionUser?> restoreSession() async {
    if (isAuthenticated) {
      return const SessionUser(id: 'user_1', email: 'test@example.com');
    }
    return null;
  }
}

class MemoryStorage extends NanoStorage {
  final Map<String, dynamic> _data = {};

  @override
  T? get<T>(String key) => _data[key] as T?;

  @override
  void set<T>(String key, T value) => _data[key] = value;

  @override
  void delete(String key) => _data.remove(key);

  @override
  void clear({String? prefix}) => _data.clear();

  @override
  bool has(String key) => _data.containsKey(key);
}

void main() {
  group('NanoAuthRepository', () {
    late MemoryStorage storage;
    late TestAuthRepository repo;

    setUp(() {
      storage = MemoryStorage();
      repo = TestAuthRepository(storage: storage);
    });

    test('saveToken persists token and refreshToken', () {
      expect(repo.isAuthenticated, isFalse);

      repo.saveToken('access_token_123', refreshToken: 'refresh_token_456');
      expect(repo.isAuthenticated, isTrue);
      expect(repo.token, 'access_token_123');
      expect(repo.refreshToken, 'refresh_token_456');
    });

    test('clearSession removes all auth tokens', () {
      repo.saveToken('token_abc', refreshToken: 'refresh_def');
      expect(repo.isAuthenticated, isTrue);

      repo.clearSession();
      expect(repo.isAuthenticated, isFalse);
      expect(repo.token, isNull);
      expect(repo.refreshToken, isNull);
    });

    test('restoreSession returns user when token exists', () async {
      expect(await repo.restoreSession(), isNull);

      repo.saveToken('valid_jwt');
      final session = await repo.restoreSession();
      expect(session?.id, 'user_1');
      expect(session?.email, 'test@example.com');
    });

    test('logout clears session', () async {
      repo.saveToken('valid_jwt');
      expect(repo.isAuthenticated, isTrue);

      await repo.logout();
      expect(repo.isAuthenticated, isFalse);
    });
  });
}
