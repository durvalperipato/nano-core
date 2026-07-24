import 'dart:async';
import 'package:nano_core/src/state/nano_state_content.dart';

/// A base controller class to manage states extending [NanoStateContent].
///
/// It uses a [StreamController] to broadcast state changes.
abstract class NanoController<T extends NanoStateContent> {
  T _state;
  final StreamController<T> _stateController = StreamController<T>.broadcast();

  /// The current state of the controller.
  T get state => _state;

  /// A stream that emits new states.
  Stream<T> get stateStream => _stateController.stream;

  /// Initializes the controller with a given [initialState].
  NanoController({required T initialState}) : _state = initialState;

  /// Initialization method to set up any necessary resources.
  ///
  /// Can optionally receive an [id].
  Future<void> init(String? id) async {}

  /// Emits a new [state] to the [stateStream] if it's different from the current one.
  void emit(T state) {
    if (_state == state) return;
    _state = state;
    _stateController.add(state);
  }

  /// Closes the [StreamController] and releases resources.
  void dispose() => _stateController.close();
}
