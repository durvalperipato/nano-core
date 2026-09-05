import 'nano_oauth_grant_type.dart';
import 'nano_pkce.dart';

/// Central utility for constructing standardized OAuth 2.0 authorization URLs,
/// token request payloads, and PKCE parameters across any identity provider.
abstract final class NanoOAuth {
  /// Constructs a complete, standards-compliant OAuth 2.0 authorization [Uri].
  ///
  /// - [authorizationEndpoint]: The provider's authorization URL (e.g.
  ///   `'https://discord.com/api/oauth2/authorize'`).
  /// - [clientId]: The registered client application identifier.
  /// - [redirectUri]: The registered redirect URI or custom scheme deep link.
  /// - [scopes]: List of permissions requested from the user.
  /// - [pkce]: Optional [NanoPkce] instance supplying code_challenge, method,
  ///   state, and nonce.
  /// - [responseType]: OAuth response type. Defaults to `'code'`.
  /// - [state]: Explicit anti-CSRF state token if not provided by [pkce].
  /// - [nonce]: Explicit OIDC nonce token if not provided by [pkce].
  /// - [extraParameters]: Additional custom query parameters required by
  ///   specific identity providers.
  static Uri buildAuthorizationUri({
    required String authorizationEndpoint,
    required String clientId,
    required String redirectUri,
    List<String> scopes = const [],
    NanoPkce? pkce,
    String responseType = 'code',
    String? state,
    String? nonce,
    Map<String, String>? extraParameters,
  }) {
    final queryParams = <String, String>{
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': responseType,
    };

    if (scopes.isNotEmpty) {
      queryParams['scope'] = scopes.join(' ');
    }

    final effectiveState = pkce?.state ?? state;
    if (effectiveState != null && effectiveState.isNotEmpty) {
      queryParams['state'] = effectiveState;
    }

    if (pkce != null) {
      queryParams['code_challenge'] = pkce.codeChallenge;
      queryParams['code_challenge_method'] = pkce.method.value;
    }

    final effectiveNonce = pkce?.nonce ?? nonce;
    if (effectiveNonce != null && effectiveNonce.isNotEmpty) {
      queryParams['nonce'] = effectiveNonce;
    }

    if (extraParameters != null && extraParameters.isNotEmpty) {
      queryParams.addAll(extraParameters);
    }

    return Uri.parse(
      authorizationEndpoint,
    ).replace(queryParameters: queryParams);
  }

  /// Builds a standard `application/x-www-form-urlencoded` payload to exchange
  /// an authorization code for access and refresh tokens.
  static Map<String, String> buildAuthorizationCodeBody({
    required String code,
    required String redirectUri,
    required String codeVerifier,
    String? clientId,
    String? clientSecret,
    Map<String, String>? extraParameters,
  }) {
    final body = <String, String>{
      'grant_type': NanoOAuthGrantType.authorizationCode.value,
      'code': code,
      'redirect_uri': redirectUri,
      'code_verifier': codeVerifier,
    };

    if (clientId != null && clientId.isNotEmpty) {
      body['client_id'] = clientId;
    }

    if (clientSecret != null && clientSecret.isNotEmpty) {
      body['client_secret'] = clientSecret;
    }

    if (extraParameters != null) {
      body.addAll(extraParameters);
    }

    return body;
  }

  /// Builds a standard token request payload for the Refresh Token flow.
  static Map<String, String> buildRefreshTokenBody({
    required String refreshToken,
    String? clientId,
    String? clientSecret,
    List<String>? scopes,
    Map<String, String>? extraParameters,
  }) {
    final body = <String, String>{
      'grant_type': NanoOAuthGrantType.refreshToken.value,
      'refresh_token': refreshToken,
    };

    if (clientId != null && clientId.isNotEmpty) {
      body['client_id'] = clientId;
    }

    if (clientSecret != null && clientSecret.isNotEmpty) {
      body['client_secret'] = clientSecret;
    }

    if (scopes != null && scopes.isNotEmpty) {
      body['scope'] = scopes.join(' ');
    }

    if (extraParameters != null) {
      body.addAll(extraParameters);
    }

    return body;
  }

  /// Builds a standard token request payload for the Resource Owner Password
  /// Credentials grant.
  static Map<String, String> buildPasswordBody({
    required String username,
    required String password,
    String? clientId,
    String? clientSecret,
    List<String>? scopes,
    Map<String, String>? extraParameters,
  }) {
    final body = <String, String>{
      'grant_type': NanoOAuthGrantType.password.value,
      'username': username,
      'password': password,
    };

    if (clientId != null && clientId.isNotEmpty) {
      body['client_id'] = clientId;
    }

    if (clientSecret != null && clientSecret.isNotEmpty) {
      body['client_secret'] = clientSecret;
    }

    if (scopes != null && scopes.isNotEmpty) {
      body['scope'] = scopes.join(' ');
    }

    if (extraParameters != null) {
      body.addAll(extraParameters);
    }

    return body;
  }

  /// Builds a standard token request payload for the Client Credentials grant.
  static Map<String, String> buildClientCredentialsBody({
    required String clientId,
    required String clientSecret,
    List<String>? scopes,
    Map<String, String>? extraParameters,
  }) {
    final body = <String, String>{
      'grant_type': NanoOAuthGrantType.clientCredentials.value,
      'client_id': clientId,
      'client_secret': clientSecret,
    };

    if (scopes != null && scopes.isNotEmpty) {
      body['scope'] = scopes.join(' ');
    }

    if (extraParameters != null) {
      body.addAll(extraParameters);
    }

    return body;
  }

  /// Builds a standard token request payload for the Device Code grant
  /// (RFC 8628).
  static Map<String, String> buildDeviceCodeBody({
    required String clientId,
    required String deviceCode,
    String? clientSecret,
    Map<String, String>? extraParameters,
  }) {
    final body = <String, String>{
      'grant_type': NanoOAuthGrantType.deviceCode.value,
      'client_id': clientId,
      'device_code': deviceCode,
    };

    if (clientSecret != null && clientSecret.isNotEmpty) {
      body['client_secret'] = clientSecret;
    }

    if (extraParameters != null) {
      body.addAll(extraParameters);
    }

    return body;
  }
}
