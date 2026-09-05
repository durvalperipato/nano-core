import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  group('Nano Routes', () {
    test('NanoAnimatedRoute factories instantiate correctly', () {
      final fade = NanoAnimatedRoute.fade(
        path: '/fade',
        builder: (context, _) => const SizedBox.shrink(),
      );
      expect(fade.path, '/fade');

      final slideRight = NanoAnimatedRoute.slideRight(
        path: '/slide',
        builder: (context, _) => const SizedBox.shrink(),
      );
      expect(slideRight.path, '/slide');

      final slideUp = NanoAnimatedRoute.slideUp(
        path: '/modal',
        builder: (context, _) => const SizedBox.shrink(),
      );
      expect(slideUp.path, '/modal');

      final scale = NanoAnimatedRoute.scale(
        path: '/scale',
        builder: (context, _) => const SizedBox.shrink(),
      );
      expect(scale.path, '/scale');
    });

    test('NanoRedirectRoute stores redirect target', () {
      final redirect = NanoRedirectRoute(
        path: '/old-path',
        redirectTo: '/new-path',
      );
      expect(redirect.path, '/old-path');
      expect(redirect.redirectTo, '/new-path');
    });

    test('NanoGroupRoute stores path prefix and nested routes', () {
      final group = NanoGroupRoute(
        path: '/admin',
        routes: [
          NanoRoute(
            path: '/users',
            builder: (context, _) => const SizedBox.shrink(),
          ),
        ],
      );
      expect(group.path, '/admin');
      expect(group.routes.length, 1);
      expect(group.routes.first.path, '/users');
    });

    test('NanoProtectedRoute stores guard and destination', () {
      final protected = NanoProtectedRoute(
        hasAccess: (context, args) => false,
        redirectTo: '/login',
        routes: [
          NanoRoute(
            path: '/secret',
            builder: (context, _) => const SizedBox.shrink(),
          ),
        ],
      );

      expect(protected.redirectTo, '/login');
      expect(protected.routes.length, 1);
    });
  });
}
