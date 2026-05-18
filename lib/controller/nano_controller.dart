import 'dart:async';
import 'package:nano_core/state/nano_state_content.dart';

abstract class NanoController<T extends NanoStateContent> {
  T _state;
  final StreamController<T> _stateController = StreamController<T>.broadcast();

  T get state => _state;
  Stream<T> get stateStream => _stateController.stream;

  NanoController({required T initialState}) : _state = initialState;

  Future<void> init(String? id) async {}

  void emit(T state) {
    if (_state == state) return;
    _state = state;
    _stateController.add(state);
  }

  void dispose() => _stateController.close();
}
