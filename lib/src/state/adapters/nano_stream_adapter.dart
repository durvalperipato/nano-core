import 'dart:async';
import 'package:flutter/foundation.dart';
import '../nano_state.dart';
import '../nano_state_observable.dart';
import '../nano_view_state.dart';

/// A generic reactive adapter bridging any [Stream] (such as BLoC, Cubit,
/// RxDart, or WebSocket streams) into a [NanoStateObservable].
class NanoStreamAdapter<T extends NanoViewState, S> extends ChangeNotifier
    implements NanoStateObservable<T> {
  /// Creates a [NanoStreamAdapter] instance.
  NanoStreamAdapter({
    required Stream<S> stream,
    required NanoState<T> initialState,
    NanoState<T> Function(S event)? mapper,
  })  : _state = initialState,
        _mapper = mapper {
    _subscription = stream.listen(
      (event) {
        if (_mapper != null) {
          _state = _mapper(event);
        } else if (event is NanoState<T>) {
          _state = event;
        }
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        _state = ErrorState<T>(null);
        notifyListeners();
      },
    );
  }

  final NanoState<T> Function(S event)? _mapper;
  late final StreamSubscription<S> _subscription;
  NanoState<T> _state;

  @override
  NanoState<T> get state => _state;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
