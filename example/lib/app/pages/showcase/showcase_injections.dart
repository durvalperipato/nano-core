import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_models.dart';
import '../../mocks/mock_user_injections.dart';
import 'showcase_controller.dart';

/// Dependency injection bindings for the showcase page scope.
class ShowcaseInjections extends NanoInjections {
  /// Creates a new [ShowcaseInjections] scope.
  ShowcaseInjections() : super(scope: 'showcase');

  @override
  void binds(GetIt i) {
    // 🧩 Composes modular data layer dependencies:
    const MockUserInjections().binds(i);

    // Page-specific controller registration:
    i.registerFactory<ShowcaseController>(
      () => ShowcaseController(userRepository: i<MockUserRepository>()),
    );
  }
}


