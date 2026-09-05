import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('NanoPkce', () {
    test('generate produces valid S256 credentials by default', () {
      final pkce = NanoPkce.generate();

      expect(pkce.codeVerifier, isNotEmpty);
      expect(pkce.codeChallenge, isNotEmpty);
      expect(pkce.method, equals(NanoPkceMethod.s256));
      expect(pkce.state, isNotEmpty);
      expect(pkce.nonce, isNull);
      expect(pkce.codeVerifier.contains('='), isFalse);
      expect(pkce.codeChallenge.contains('='), isFalse);
    });

    test('generate with includeNonce generates an OIDC nonce', () {
      final pkce = NanoPkce.generate(includeNonce: true);

      expect(pkce.nonce, isNotNull);
      expect(pkce.nonce, isNotEmpty);
    });

    test('generate with plain method produces challenge equal to verifier', () {
      final pkce = NanoPkce.generate(method: NanoPkceMethod.plain);

      expect(pkce.method, equals(NanoPkceMethod.plain));
      expect(pkce.codeChallenge, equals(pkce.codeVerifier));
    });

    test('createChallenge correctly hashes known RFC 7636 test vector', () {
      // RFC 7636 Appendix B test vector:
      // Verifier: dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk
      // S256 Challenge: E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM
      const verifier = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';
      const expectedChallenge = 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM';

      final challenge = NanoPkce.createChallenge(verifier);
      expect(challenge, equals(expectedChallenge));
    });

    test('randomString generates requested entropy byte length', () {
      final str1 = NanoPkce.randomString(16);
      final str2 = NanoPkce.randomString(32);

      expect(str1, isNotEmpty);
      expect(str2, isNotEmpty);
      expect(str2.length, greaterThan(str1.length));
    });
  });
}
