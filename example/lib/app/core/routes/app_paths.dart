import 'package:nano_core/nano_core.dart';

/// Application URL paths and path segments.
abstract final class AppPaths {
  /// Root showcase dashboard path ('/').
  static const String root = NanoPaths.root;

  /// Home alias redirect path ('/home').
  static const String home = '/home';

  /// Users module base path ('/users').
  static const String users = '/users';

  /// Detail sub-path ('/detail').
  static const String detail = NanoPaths.detail;

  /// Admin module group prefix ('/admin').
  static const String admin = '/admin';

  /// Admin panel sub-path ('/panel').
  static const String panel = '/panel';

  /// Authentication page path ('/login').
  static const String login = '/login';

  /// Shell scaffold demo path ('/shell-demo').
  static const String shellDemo = '/shell-demo';
}
