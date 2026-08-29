import 'dart:async';
import 'package:nano_core/nano_core.dart';
import '../../mocks/mock_api.dart';
import '../../mocks/mock_models.dart';
import 'showcase_messages.dart';
import 'showcase_state.dart';

/// Controller managing state, commands, and mock async operations for Showcase.
class ShowcaseController extends NanoController<ShowcaseViewState> {
  /// User repository for fetching user data.
  final MockUserRepository userRepository;

  /// Local Command to fetch a User.
  late final NanoCommand0<MockUser?> fetchUserCommand;

  /// Local Command to fetch a list of Companies.
  late final NanoCommand0<List<MockCompany>> fetchCompaniesCommand;

  /// Creates a new [ShowcaseController] instance.
  ShowcaseController({required this.userRepository}) {
    fetchUserCommand = NanoCommand0<MockUser?>(() async {
      return userRepository.getById('1');
    });

    fetchCompaniesCommand = NanoCommand0<List<MockCompany>>(() async {
      return MockApi.fetchCompanies();
    });
  }

  /// Simulates an async operation returning success.
  Future<void> simulateSuccess() async {
    unawaited(
      execute(() async {
        await Future.delayed(const Duration(milliseconds: 1500));
        return const ShowcaseViewState(
          message: 'Dashboard analytics updated successfully!',
        );
      }),
    );
  }

  /// Simulates an async operation returning a warning state.
  Future<void> simulateWarning() async {
    emit(state.toLoading());
    await Future.delayed(const Duration(milliseconds: 1200));
    emit(state.toWarning(key: ShowcaseMessages.warningRateLimit));
  }

  /// Simulates an async operation returning an error.
  Future<void> simulateError() async {
    emit(state.toLoading());
    await Future.delayed(const Duration(milliseconds: 1200));
    emit(state.toError(key: ShowcaseMessages.errorBackend));
  }

  /// Triggers a global fetch which updates the controller state,
  /// causing the NanoScaffold to show the NanoLoadingOverlay in the center.
  Future<void> simulateGlobalFetch() async {
    unawaited(
      execute(() async {
        final users = await userRepository.getAll();
        return ShowcaseViewState(
          users: users,
          message: 'Global Data Fetched: ${users.length} users from NanoRepository',
        );
      }),
    );
  }

  /// Resets controller state to initial.
  void resetState() {
    emit(const InitialState<ShowcaseViewState>());
  }
}
