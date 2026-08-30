import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';
import 'mock_models.dart';

/// Reusable modular injection scope for user data layer dependencies.
class MockUserInjections extends NanoInjections {
  /// Creates a new [MockUserInjections] instance.
  const MockUserInjections({super.scope = 'user_data'});

  @override
  void binds(GetIt i) {
    i.registerLazySingleton<MockUserRepository>(
      () => MockUserRepository(i<NanoHttpClient>()),
    );
  }
}
