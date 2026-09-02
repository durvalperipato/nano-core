import 'package:get_it/get_it.dart';
import '../entity/nano_entity.dart';
import '../http/nano_http_client.dart';
import '../storage/nano_storage.dart';

/// An abstract repository for handling user authentication, session
/// persistence, and token lifecycle management.
abstract class NanoAuthRepository<Session extends NanoEntity<dynamic>> {
  /// Creates a [NanoAuthRepository] instance.
  ///
  /// If [client] or [storage] are omitted, they automatically resolve from
  /// [GetIt].
  const NanoAuthRepository({
    required this.endpoint,
    this.tokenKey = defaultTokenKey,
    this.refreshTokenKey = defaultRefreshTokenKey,
    NanoHttpClient? client,
    NanoStorage? storage,
  }) : _client = client,
       _storage = storage;

  /// Default storage key for authentication access tokens.
  static const String defaultTokenKey = 'auth_token';

  /// Default storage key for refresh tokens.
  static const String defaultRefreshTokenKey = 'refresh_token';

  final NanoHttpClient? _client;
  final NanoStorage? _storage;

  /// The base endpoint URL path for authentication operations (e.g., `/auth`).
  final String endpoint;

  /// Key used to store/retrieve the authentication access token in [storage].
  final String tokenKey;

  /// Key used to store/retrieve the refresh token in [storage].
  final String refreshTokenKey;

  /// The HTTP client used to perform requests.
  NanoHttpClient get client => _client ?? GetIt.I<NanoHttpClient>();

  /// The active storage store.
  NanoStorage? get storage =>
      _storage ??
      (GetIt.I.isRegistered<NanoStorage>() ? GetIt.I<NanoStorage>() : null);

  /// Retrieves the current stored access token.
  String? get token => storage?.get<String>(tokenKey);

  /// Retrieves the current stored refresh token.
  String? get refreshToken => storage?.get<String>(refreshTokenKey);

  /// Checks if a non-empty access token is present in [storage].
  bool get isAuthenticated => token != null && token!.isNotEmpty;

  /// Saves the access token (and optionally [refreshToken]) to [storage].
  void saveToken(String token, {String? refreshToken}) {
    storage?.set(tokenKey, token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      storage?.set(refreshTokenKey, refreshToken);
    }
  }

  /// Clears stored authentication and refresh tokens from [storage].
  void clearSession() {
    storage?.delete(tokenKey);
    storage?.delete(refreshTokenKey);
  }

  /// Restores and validates the current active user session.
  ///
  /// Subclasses can optionally override this method to perform profile
  /// retrieval or validation. Defaults to returning `null`.
  Future<Session?> restoreSession() async => null;

  /// Logs out the user and clears the current session.
  Future<void> logout() async => clearSession();
}
