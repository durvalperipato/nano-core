import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_models.dart';

/// Structured view state for the Showcase page.
class ShowcaseViewState extends NanoViewState {
  /// Optional message from analytics or user actions.
  final String? message;

  /// List of users fetched via [MockUserRepository].
  final List<MockUser> users;

  /// List of companies fetched via API.
  final List<MockCompany> companies;

  /// Creates a new [ShowcaseViewState] instance.
  const ShowcaseViewState({
    this.message,
    this.users = const [],
    this.companies = const [],
  });

  /// Creates a copy of this state with updated values.
  ShowcaseViewState copyWith({
    String? message,
    List<MockUser>? users,
    List<MockCompany>? companies,
  }) {
    return ShowcaseViewState(
      message: message ?? this.message,
      users: users ?? this.users,
      companies: companies ?? this.companies,
    );
  }

  @override
  List<Object?> get props => [message, users, companies];
}
