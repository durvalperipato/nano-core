import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_models.dart';
import 'users_state.dart';

/// Controller managing the users list state and API requests.
class UsersController extends NanoController<UsersState> {
  /// The user repository used to fetch data.
  final MockUserRepository userRepository;

  /// Creates a new [UsersController] instance.
  UsersController({required this.userRepository});

  @override
  Future<void> init(String? id) async {
    await fetchUsers();
  }

  /// Fetches users from the mock HTTP repository.
  Future<void> fetchUsers() async {
    execute(() async {
      final users = await userRepository.getAll();
      return UsersState(users: users);
    });
  }
}
