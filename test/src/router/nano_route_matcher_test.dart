import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';
import 'package:nano_core/src/router/internal/nano_route_matcher.dart';

void main() {
  group('NanoRouteMatcher', () {
    final dummyRoute = NanoRoute(
      path: '/dummy',
      builder: (context, _) => const SizedBox(),
    );

    test('identifies dynamic patterns correctly', () {
      expect(NanoRouteMatcher.isDynamicPattern('/home'), isFalse);
      expect(NanoRouteMatcher.isDynamicPattern('/users/profile'), isFalse);
      expect(NanoRouteMatcher.isDynamicPattern('/users/:id'), isTrue);
      expect(NanoRouteMatcher.isDynamicPattern('/files/*path'), isTrue);
    });

    test('matches single path parameter and extracts value', () {
      final matcher = NanoRouteMatcher(
        pattern: '/users/:id',
        route: dummyRoute,
      );

      final match = matcher.match('/users/42');
      expect(match, isNotNull);
      expect(match!.canonicalPath, equals('/users/:id'));
      expect(match.pathParameters['id'], equals('42'));
    });

    test('matches multiple path parameters in hierarchy', () {
      final matcher = NanoRouteMatcher(
        pattern: '/orgs/:orgId/projects/:projectId',
        route: dummyRoute,
      );

      final match = matcher.match('/orgs/google/projects/flutter');
      expect(match, isNotNull);
      expect(match!.pathParameters['orgId'], equals('google'));
      expect(match.pathParameters['projectId'], equals('flutter'));
    });

    test('handles trailing slashes gracefully', () {
      final matcher = NanoRouteMatcher(
        pattern: '/items/:id',
        route: dummyRoute,
      );

      final match = matcher.match('/items/99/');
      expect(match, isNotNull);
      expect(match!.pathParameters['id'], equals('99'));
    });

    test('decodes URL-encoded parameter values', () {
      final matcher = NanoRouteMatcher(
        pattern: '/search/:query',
        route: dummyRoute,
      );

      final match = matcher.match('/search/hello%20world');
      expect(match, isNotNull);
      expect(match!.pathParameters['query'], equals('hello world'));
    });

    test('supports wildcard catch-all patterns', () {
      final matcher = NanoRouteMatcher(
        pattern: '/docs/*filepath',
        route: dummyRoute,
      );

      final match = matcher.match('/docs/guides/getting-started.html');
      expect(match, isNotNull);
      expect(
        match!.pathParameters['filepath'],
        equals('guides/getting-started.html'),
      );
    });

    test('returns null for non-matching paths', () {
      final matcher = NanoRouteMatcher(
        pattern: '/users/:id',
        route: dummyRoute,
      );

      expect(matcher.match('/users'), isNull);
      expect(matcher.match('/users/42/details'), isNull);
      expect(matcher.match('/products/42'), isNull);
    });
  });

  group('NanoRouteArgs', () {
    test('extracts path and query parameters with typed helpers', () {
      const args = NanoRouteArgs(
        pathParameters: {'id': '101', 'name': 'John'},
        queryParameters: {
          'active': 'true',
          'page': '3',
          'rate': '4.5',
          'filter': 'all',
        },
      );

      expect(args.pathParam('id'), equals('101'));
      expect(args.pathParam('missing'), isNull);

      expect(args.queryParam('filter'), equals('all'));
      expect(args.queryParamInt('page'), equals(3));
      expect(args.queryParamInt('missing', defaultValue: 1), equals(1));

      expect(args.queryParamBool('active'), isTrue);
      expect(args.queryParamBool('missing', defaultValue: false), isFalse);

      expect(args.queryParamDouble('rate'), equals(4.5));
      expect(args.queryParamDouble('missing'), isNull);
    });

    test('get<T> falls back to path and query parameters', () {
      const args = NanoRouteArgs(
        pathParameters: {'id': '55'},
        queryParameters: {'limit': '20', 'debug': 'true'},
      );

      expect(args.get<String>('id'), equals('55'));
      expect(args.get<int>('id'), equals(55));
      expect(args.get<int>('limit'), equals(20));
      expect(args.get<bool>('debug'), isTrue);
      expect(args.has('id'), isTrue);
      expect(args.has('limit'), isTrue);
      expect(args.has('unknown'), isFalse);
    });

    test('in-memory data takes precedence in get<T>', () {
      const args = NanoRouteArgs(
        data: {'id': 999},
        pathParameters: {'id': '111'},
      );

      expect(args.get<int>('id'), equals(999));
    });
  });
}
