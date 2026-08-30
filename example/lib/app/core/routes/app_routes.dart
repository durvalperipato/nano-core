import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_models.dart';
import '../../pages/login/login_page.dart';
import '../../pages/showcase/showcase_page.dart';
import '../../pages/users/subpages/user_detail/user_detail_page.dart';
import '../../pages/users/users_page.dart';
import 'app_paths.dart';
import 'app_route_names.dart';

/// Central declarative router configuration for the example application.
final appRouter = NanoRouter(
  initialRoute: AppPaths.root,
  routes: [
    // Main showcase dashboard:
    NanoRoute(
      name: AppRouteNames.showcase,
      path: AppPaths.root,
      builder: (context, args) => const ShowcasePage(),
    ),

    // Users list with nested sub-routes:
    NanoRoute(
      name: AppRouteNames.users,
      path: AppPaths.users,
      builder: (context, args) => const UsersPage(),
      routes: [
        // Sub-route: /users/detail with automatic generic typing:
        NanoDetailsRoute<MockUser>(
          name: AppRouteNames.userDetail,
          builder: (context, user) => UserDetailPage(user: user),
        ),
      ],
    ),

    // Public authentication page:
    NanoRoute(
      name: AppRouteNames.login,
      path: AppPaths.login,
      builder: (context, args) => const LoginPage(),
    ),

    // Protected area with route guard wrapping admin routes:
    NanoProtectedRoute(
      hasAccess: (context, args) => false,
      redirectTo: AppRouteNames.login,
      routes: [
        NanoGroupRoute(
          path: AppPaths.admin,
          routes: [
            NanoRoute(
              name: AppRouteNames.admin,
              path: AppPaths.panel,
              builder: (context, args) => const Scaffold(
                body: Center(child: Text('Admin Secret Area')),
              ),
            ),
          ],
        ),
      ],
    ),

    // Alias redirect route:
    NanoRedirectRoute(
      path: AppPaths.home,
      redirectTo: AppRouteNames.showcase,
    ),
  ],
);
