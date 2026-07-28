import 'package:nano_core/nano_core.dart';

/// Controller managing state, commands, and mock async operations for Showcase.
class ShowcaseController extends NanoController<String> {
  /// Command for triggering reactive background tasks.
  late final NanoCommand0<String> fetchUserCommand;

  ShowcaseController() {
    fetchUserCommand = NanoCommand0<String>(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'User profile fetched successfully!';
    });
  }

  /// Simulates an async operation returning success.
  Future<void> simulateSuccess() async {
    execute(() async {
      await Future.delayed(const Duration(milliseconds: 1500));
      return 'Dashboard analytics updated successfully!';
    });
  }

  /// Simulates an async operation returning a warning state.
  Future<void> simulateWarning() async {
    emit(state.toLoading());
    await Future.delayed(const Duration(milliseconds: 1200));
    emit(state.toWarning('API rate limit reached (80%). Slowing down...'));
  }

  /// Simulates an async operation returning an error.
  Future<void> simulateError() async {
    execute(() async {
      await Future.delayed(const Duration(milliseconds: 1200));
      throw Exception('Failed to connect to backend server. (HTTP 500)');
    });
  }

  /// Resets controller state to initial.
  void resetState() {
    emit(const NanoState<String>());
  }
}
