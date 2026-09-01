import 'package:flutter/foundation.dart';
import '../nano_state.dart';
import '../nano_state_observable.dart';
import '../nano_view_state.dart';

/// A generic reactive adapter bridging any [Listenable] (such as MobX,
/// Signals, ValueNotifier, or ChangeNotifier) into a [NanoStateObservable].
class NanoListenableAdapter<ViewState extends NanoViewState>
    extends ChangeNotifier
    implements NanoStateObservable<ViewState> {
  /// Creates a [NanoListenableAdapter] instance.
  NanoListenableAdapter({
    required Listenable listenable,
    required NanoState<ViewState> Function() stateGetter,
  })  : _listenable = listenable,
        _stateGetter = stateGetter {
    _listenable.addListener(_onListenableChanged);
  }

  final Listenable _listenable;
  final NanoState<ViewState> Function() _stateGetter;

  void _onListenableChanged() => notifyListeners();

  @override
  NanoState<ViewState> get state => _stateGetter();

  @override
  void dispose() {
    _listenable.removeListener(_onListenableChanged);
    super.dispose();
  }
}
