import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_models.dart';

/// State model for the Users list page.
class UsersState extends NanoViewState {
  /// The list of loaded users.
  final List<MockUser> users;

  /// Creates a new [UsersState] instance.
  const UsersState({this.users = const []});

  /// Creates a copy with optional updated values.
  UsersState copyWith({List<MockUser>? users}) {
    return UsersState(users: users ?? this.users);
  }

  @override
  List<Object?> get props => [users];
}
