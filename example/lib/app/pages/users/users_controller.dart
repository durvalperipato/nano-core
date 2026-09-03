import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_models.dart';
import 'users_state.dart';

/// Controller managing the users list state and API requests.
class UsersController extends NanoController<UsersState> {
  /// The user search repository used to fetch and search data.
  final MockUserSearchRepository userRepository;

  /// Creates a new [UsersController] instance.
  UsersController({
    required this.userRepository,
    super.initialState = const UsersState(),
  });

  @override
  Future<void> init(String? id) async {
    await fetchUsers();
  }

  /// Fetches all users from the repository.
  Future<void> fetchUsers() async {
    execute(() async {
      final result = await userRepository.getAll();
      return UsersState(users: result.items);
    });
  }

  /// Searches users using the typed [MockUserFilter].
  Future<void> searchUsers(String query) async {
    execute(() async {
      final filter = MockUserFilter(
        name: query.trim().isNotEmpty ? query.trim() : null,
      );
      final result = await userRepository.searchAll(filter);
      return UsersState(users: result.items);
    });
  }
}
