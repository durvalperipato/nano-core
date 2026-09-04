import 'dart:convert';
import 'dart:math';
import 'internal/nano_sha256.dart';
import 'nano_pkce_method.dart';

/// Cryptographically secure OAuth 2.0 PKCE (Proof Key for Code Exchange)
/// generator conforming to RFC 7636.
///
/// Encapsulates code verifiers, computed code challenges, anti-CSRF states,
/// and optional OpenID Connect nonces.
final class NanoPkce {
  /// Creates a [NanoPkce] instance with predefined credentials.
  const NanoPkce({
    required this.codeVerifier,
    required this.codeChallenge,
    required this.state,
    this.method = NanoPkceMethod.s256,
    this.nonce,
  });

  /// Generates a cryptographically random PKCE credential set, state token,
  /// and optional OIDC nonce.
  ///
  /// - [method]: PKCE challenge algorithm ([NanoPkceMethod.s256] or
  ///   [NanoPkceMethod.plain]). Defaults to [NanoPkceMethod.s256].
  /// - [verifierEntropy]: Byte count used to generate the verifier
  ///   (minimum 32 bytes). Defaults to 32 (producing a 43-character string).
  /// - [stateEntropy]: Byte count used to generate the CSRF state token.
  ///   Defaults to 24.
  /// - [includeNonce]: Whether to generate an OpenID Connect (OIDC) nonce.
  /// - [nonceEntropy]: Byte count used to generate the OIDC nonce token.
  ///   Defaults to 24.
  factory NanoPkce.generate({
    NanoPkceMethod method = NanoPkceMethod.s256,
    int verifierEntropy = 32,
    int stateEntropy = 24,
    bool includeNonce = false,
    int nonceEntropy = 24,
  }) {
    final verifier = randomString(verifierEntropy);
    final challenge = createChallenge(verifier, method: method);
    final stateToken = randomString(stateEntropy);
    final nonceToken = includeNonce ? randomString(nonceEntropy) : null;

    return NanoPkce(
      codeVerifier: verifier,
      codeChallenge: challenge,
      method: method,
      state: stateToken,
      nonce: nonceToken,
    );
  }

  /// The private cryptographic random verifier string sent to the token
  /// endpoint.
  final String codeVerifier;

  /// The public transformed challenge string sent to the authorization
  /// endpoint.
  final String codeChallenge;

  /// The PKCE algorithm method applied to compute [codeChallenge].
  final NanoPkceMethod method;

  /// Cryptographic anti-CSRF state token sent in authorization queries.
  final String state;

  /// Optional OpenID Connect (OIDC) nonce token preventing replay attacks.
  final String? nonce;

  /// Computes a code challenge from an existing [codeVerifier] string.
  static String createChallenge(
    String codeVerifier, {
    NanoPkceMethod method = NanoPkceMethod.s256,
  }) {
    switch (method) {
      case NanoPkceMethod.plain:
        return codeVerifier;
      case NanoPkceMethod.s256:
        final digest = NanoSha256.hashString(codeVerifier);
        return _toUnpaddedBase64Url(digest);
    }
  }

  /// Generates a cryptographically secure, URL-safe random string.
  static String randomString([int byteLength = 32]) {
    final random = Random.secure();
    final bytes = List<int>.generate(byteLength, (_) => random.nextInt(256));
    return _toUnpaddedBase64Url(bytes);
  }

  static String _toUnpaddedBase64Url(List<int> bytes) {
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}
