/// Supported OAuth 2.0 PKCE code challenge methods (RFC 7636).
enum NanoPkceMethod {
  /// SHA-256 code challenge with URL-safe base64 encoding (recommended).
  s256('S256'),

  /// Plain text code challenge without cryptographic hashing.
  plain('plain');

  const NanoPkceMethod(this.value);

  /// The standard query parameter value transmitted in OAuth authorization
  /// requests.
  final String value;
}
