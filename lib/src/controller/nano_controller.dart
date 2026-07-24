import 'package:flutter/foundation.dart';
import '../state/nano_state.dart';

abstract class NanoController<T> extends ChangeNotifier {
  NanoState<T> state = NanoState<T>();

  void emit(NanoState<T> newState) {
    state = newState;
    notifyListeners();
  }

  /// First method it will be called when controller runs
  Future<void> init(String? id) async {}

  /// Generic execute method for controllers that don't use explicit NanoCommands.
  Future<void> execute(Future<T> Function() action) async {
    emit(state.toLoading());
    try {
      final result = await action();
      emit(state.toSuccess(result));
    } catch (e) {
      emit(state.toFailure(e.toString()));
    }
  }
}
