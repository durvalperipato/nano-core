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
    this.tokenStorageKey = defaultTokenStorageKey,
    this.refreshTokenStorageKey = defaultRefreshTokenStorageKey,
    NanoHttpClient? client,
    NanoStorage? storage,
  }) : _client = client,
       _storage = storage;

  /// Default storage key for authentication access tokens.
  static const String defaultTokenStorageKey = 'auth.access_token';

  /// Default storage key for refresh tokens.
  static const String defaultRefreshTokenStorageKey = 'auth.refresh_token';

  final NanoHttpClient? _client;
  final NanoStorage? _storage;

  /// Key used to store/retrieve the authentication access token in [storage].
  final String tokenStorageKey;

  /// Key used to store/retrieve the refresh token in [storage].
  final String refreshTokenStorageKey;

  /// The HTTP client used to perform requests.
  NanoHttpClient get client => _client ?? GetIt.I<NanoHttpClient>();

  /// The active storage store.
  NanoStorage? get storage =>
      _storage ??
      (GetIt.I.isRegistered<NanoStorage>() ? GetIt.I<NanoStorage>() : null);

  /// Retrieves the current stored access token.
  String? get token => storage?.get<String>(tokenStorageKey);

  /// Retrieves the current stored refresh token.
  String? get refreshToken => storage?.get<String>(refreshTokenStorageKey);

  /// Checks if a non-empty access token is present in [storage].
  bool get isAuthenticated => token != null && token!.isNotEmpty;

  /// Saves the access token (and optionally [refreshToken]) to [storage].
  void saveToken(String token, {String? refreshToken}) {
    storage?.set(tokenStorageKey, token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      storage?.set(refreshTokenStorageKey, refreshToken);
    }
  }

  /// Clears stored authentication and refresh tokens from [storage].
  void clearSession() {
    storage?.delete(tokenStorageKey);
    storage?.delete(refreshTokenStorageKey);
  }

  /// Refreshes the active session using the stored [refreshToken].
  ///
  /// Subclasses should override this method to perform token renewal
  /// against their backend OAuth/JWT refresh endpoint. Defaults to returning
  /// `false`.
  Future<bool> refreshSession() async => false;

  /// Restores and validates the current active user session.
  ///
  /// Subclasses can optionally override this method to perform profile
  /// retrieval or validation. Defaults to returning `null`.
  Future<Session?> restoreSession() async => null;

  /// Logs out the user and clears the current session.
  Future<void> logout() async => clearSession();
}
