/// Parsed response from an OAuth 2.0 authorization redirect or deep link.
final class NanoOAuthCallback {
  /// Creates a [NanoOAuthCallback] model.
  const NanoOAuthCallback({
    this.code,
    this.state,
    this.error,
    this.errorDescription,
    this.rawParameters = const {},
  });

  /// Parses an OAuth callback from a redirect [Uri].
  factory NanoOAuthCallback.fromUri(Uri uri) {
    final params = uri.queryParameters;
    return NanoOAuthCallback(
      code: params['code'],
      state: params['state'],
      error: params['error'],
      errorDescription: params['error_description'],
      rawParameters: params,
    );
  }

  /// Parses an OAuth callback from a redirect URL string.
  factory NanoOAuthCallback.fromUrl(String url) =>
      NanoOAuthCallback.fromUri(Uri.parse(url));

  /// The authorization code returned on successful authentication.
  final String? code;

  /// The anti-CSRF state token returned in the callback query.
  final String? state;

  /// The OAuth error identifier returned when authorization is denied or fails.
  final String? error;

  /// Optional human-readable description of the authorization error.
  final String? errorDescription;

  /// The complete raw map of query parameters parsed from the callback URI.
  final Map<String, String> rawParameters;

  /// Whether the callback represents a successful authorization response.
  bool get isSuccess => code != null && code!.isNotEmpty && error == null;

  /// Validates whether the returned state matches the expected original state.
  bool isValidState(String? expectedState) {
    if (expectedState == null || expectedState.isEmpty) return false;
    return state == expectedState;
  }
}
