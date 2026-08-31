import 'package:flutter/foundation.dart';
import '../nano_state.dart';
import '../nano_state_observable.dart';
import '../nano_view_state.dart';

/// A generic reactive adapter bridging any [Listenable] (such as MobX,
/// Signals, ValueNotifier, or ChangeNotifier) into a [NanoStateObservable].
class NanoListenableAdapter<T extends NanoViewState> extends ChangeNotifier
    implements NanoStateObservable<T> {
  /// Creates a [NanoListenableAdapter] instance.
  NanoListenableAdapter({
    required Listenable listenable,
    required NanoState<T> Function() stateGetter,
  })  : _listenable = listenable,
        _stateGetter = stateGetter {
    _listenable.addListener(_onListenableChanged);
  }

  final Listenable _listenable;
  final NanoState<T> Function() _stateGetter;

  void _onListenableChanged() {
    notifyListeners();
  }

  @override
  NanoState<T> get state => _stateGetter();

  @override
  void dispose() {
    _listenable.removeListener(_onListenableChanged);
    super.dispose();
  }
}
