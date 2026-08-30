import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_models.dart';
import '../../mocks/mock_user_injections.dart';
import 'users_controller.dart';

/// Injections scope for the users page.
class UsersInjections extends NanoInjections {
  /// Creates a new [UsersInjections] scope.
  UsersInjections() : super(scope: 'users_page');

  @override
  void binds(GetIt i) {
    // Composes modular user data injections:
    const MockUserInjections().binds(i);

    // Registers the page controller:
    i.registerFactory<UsersController>(
      () => UsersController(userRepository: i<MockUserRepository>()),
    );
  }
}
