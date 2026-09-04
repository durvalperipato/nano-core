/// Standard OAuth 2.0 grant types supported across modern identity providers.
enum NanoOAuthGrantType {
  /// Authorization code grant with PKCE (Mobile & Web applications).
  authorizationCode('authorization_code'),

  /// Refresh token grant for renewing expired access tokens silently.
  refreshToken('refresh_token'),

  /// Resource Owner Password Credentials (direct username & password).
  password('password'),

  /// Client credentials grant for machine-to-machine & backend communication.
  clientCredentials('client_credentials'),

  /// Device authorization grant for smart TVs, consoles, and CLIs (RFC 8628).
  deviceCode('urn:ietf:params:oauth:grant-type:device_code');

  const NanoOAuthGrantType(this.value);

  /// The standard grant_type string parameter value transmitted in token
  /// requests.
  final String value;
}
