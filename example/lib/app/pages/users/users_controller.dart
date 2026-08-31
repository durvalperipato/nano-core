import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_models.dart';
import 'users_state.dart';

/// Controller managing the users list state and API requests.
class UsersController extends NanoController<UsersState> {
  /// The user search repository used to fetch and search data.
  final MockUserSearchRepository userRepository;

  /// Creates a new [UsersController] instance.
  UsersController({required this.userRepository});

  @override
  Future<void> init(String? id) async {
    await fetchUsers();
  }

  /// Fetches all users from the repository.
  Future<void> fetchUsers() async {
    execute(() async {
      final users = await userRepository.getAll();
      return UsersState(users: users);
    });
  }

  /// Searches users using the typed [MockUserFilter].
  Future<void> searchUsers(String query) async {
    execute(() async {
      final filter = MockUserFilter(
        name: query.trim().isNotEmpty ? query.trim() : null,
      );
      final users = await userRepository.search(filter);
      return UsersState(users: users);
    });
  }
}
