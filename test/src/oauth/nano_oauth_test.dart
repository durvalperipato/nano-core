import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoOAuthGrantType', () {
    test('contains all 5 RFC standard grant types', () {
      expect(
        NanoOAuthGrantType.authorizationCode.value,
        equals('authorization_code'),
      );
      expect(NanoOAuthGrantType.refreshToken.value, equals('refresh_token'));
      expect(NanoOAuthGrantType.password.value, equals('password'));
      expect(
        NanoOAuthGrantType.clientCredentials.value,
        equals('client_credentials'),
      );
      expect(
        NanoOAuthGrantType.deviceCode.value,
        equals('urn:ietf:params:oauth:grant-type:device_code'),
      );
    });
  });

  group('NanoOAuthCallback', () {
    test('fromUri parses successful callback parameters', () {
      final uri = Uri.parse(
        'myapp://oauth/callback?code=AUTH_12345&state=STATE_XYZ',
      );
      final callback = NanoOAuthCallback.fromUri(uri);

      expect(callback.isSuccess, isTrue);
      expect(callback.code, equals('AUTH_12345'));
      expect(callback.state, equals('STATE_XYZ'));
      expect(callback.error, isNull);
      expect(callback.isValidState('STATE_XYZ'), isTrue);
      expect(callback.isValidState('WRONG_STATE'), isFalse);
    });

    test('fromUrl parses error response correctly', () {
      const url =
          'myapp://oauth/callback?error=access_denied&error_description=User+cancelled';
      final callback = NanoOAuthCallback.fromUrl(url);

      expect(callback.isSuccess, isFalse);
      expect(callback.error, equals('access_denied'));
      expect(callback.errorDescription, equals('User cancelled'));
      expect(callback.code, isNull);
    });
  });

  group('NanoOAuth', () {
    test(
      'buildAuthorizationUri formats query correctly with PKCE and scopes',
      () {
        final pkce = NanoPkce.generate(includeNonce: true);
        final uri = NanoOAuth.buildAuthorizationUri(
          authorizationEndpoint: 'https://discord.com/api/oauth2/authorize',
          clientId: 'DISCORD_CLIENT_123',
          redirectUri: 'myapp://oauth/callback',
          scopes: ['identify', 'email'],
          pkce: pkce,
          extraParameters: {'prompt': 'consent'},
        );

        expect(uri.scheme, equals('https'));
        expect(uri.host, equals('discord.com'));
        expect(uri.path, equals('/api/oauth2/authorize'));
        expect(uri.queryParameters['client_id'], equals('DISCORD_CLIENT_123'));
        expect(
          uri.queryParameters['redirect_uri'],
          equals('myapp://oauth/callback'),
        );
        expect(uri.queryParameters['response_type'], equals('code'));
        expect(uri.queryParameters['scope'], equals('identify email'));
        expect(uri.queryParameters['state'], equals(pkce.state));
        expect(
          uri.queryParameters['code_challenge'],
          equals(pkce.codeChallenge),
        );
        expect(uri.queryParameters['code_challenge_method'], equals('S256'));
        expect(uri.queryParameters['nonce'], equals(pkce.nonce));
        expect(uri.queryParameters['prompt'], equals('consent'));
      },
    );

    test('buildAuthorizationCodeBody generates standard payload', () {
      final body = NanoOAuth.buildAuthorizationCodeBody(
        clientId: 'CLIENT_ID',
        code: 'CODE_123',
        redirectUri: 'myapp://callback',
        codeVerifier: 'VERIFIER_SECRET',
        clientSecret: 'SECRET_XYZ',
      );

      expect(body['grant_type'], equals('authorization_code'));
      expect(body['client_id'], equals('CLIENT_ID'));
      expect(body['code'], equals('CODE_123'));
      expect(body['redirect_uri'], equals('myapp://callback'));
      expect(body['code_verifier'], equals('VERIFIER_SECRET'));
      expect(body['client_secret'], equals('SECRET_XYZ'));
    });

    test('buildRefreshTokenBody generates standard payload', () {
      final body = NanoOAuth.buildRefreshTokenBody(
        clientId: 'CLIENT_ID',
        refreshToken: 'REFRESH_TOKEN_123',
        scopes: ['offline_access'],
      );

      expect(body['grant_type'], equals('refresh_token'));
      expect(body['client_id'], equals('CLIENT_ID'));
      expect(body['refresh_token'], equals('REFRESH_TOKEN_123'));
      expect(body['scope'], equals('offline_access'));

      final simpleBody = NanoOAuth.buildRefreshTokenBody(
        refreshToken: 'REFRESH_TOKEN_123',
      );
      expect(simpleBody['grant_type'], equals('refresh_token'));
      expect(simpleBody['refresh_token'], equals('REFRESH_TOKEN_123'));
      expect(simpleBody.containsKey('client_id'), isFalse);
    });

    test('buildPasswordBody generates standard payload', () {
      final body = NanoOAuth.buildPasswordBody(
        clientId: 'CLIENT_ID',
        username: 'user@example.com',
        password: 'password123',
      );

      expect(body['grant_type'], equals('password'));
      expect(body['client_id'], equals('CLIENT_ID'));
      expect(body['username'], equals('user@example.com'));
      expect(body['password'], equals('password123'));
    });

    test('buildClientCredentialsBody generates standard payload', () {
      final body = NanoOAuth.buildClientCredentialsBody(
        clientId: 'CLIENT_ID',
        clientSecret: 'CLIENT_SECRET',
      );

      expect(body['grant_type'], equals('client_credentials'));
      expect(body['client_id'], equals('CLIENT_ID'));
      expect(body['client_secret'], equals('CLIENT_SECRET'));
    });

    test('buildDeviceCodeBody generates standard payload', () {
      final body = NanoOAuth.buildDeviceCodeBody(
        clientId: 'CLIENT_ID',
        deviceCode: 'DEVICE_CODE_123',
      );

      expect(
        body['grant_type'],
        equals('urn:ietf:params:oauth:grant-type:device_code'),
      );
      expect(body['client_id'], equals('CLIENT_ID'));
      expect(body['device_code'], equals('DEVICE_CODE_123'));
    });
  });
}
