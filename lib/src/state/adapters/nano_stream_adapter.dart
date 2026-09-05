import 'dart:async';
import 'package:flutter/foundation.dart';
import '../nano_state.dart';
import '../nano_state_observable.dart';
import '../nano_view_state.dart';

/// A generic reactive adapter bridging any [Stream] (such as BLoC, Cubit,
/// RxDart, or WebSocket streams) into a [NanoStateObservable].
class NanoStreamAdapter<ViewState extends NanoViewState, StreamEvent>
    extends ChangeNotifier
    implements NanoStateObservable<ViewState> {
  /// Creates a [NanoStreamAdapter] instance.
  NanoStreamAdapter({
    required Stream<StreamEvent> stream,
    required NanoState<ViewState> initialState,
    NanoState<ViewState> Function(StreamEvent event)? mapper,
  }) : _state = initialState,
       _mapper = mapper {
    _subscription = stream.listen(
      (event) {
        if (_mapper != null) {
          _state = _mapper(event);
        } else if (event is NanoState<ViewState>) {
          _state = event;
        }
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        _state = ErrorState<ViewState>(null);
        notifyListeners();
      },
    );
  }

  final NanoState<ViewState> Function(StreamEvent event)? _mapper;
  late final StreamSubscription<StreamEvent> _subscription;
  NanoState<ViewState> _state;

  @override
  NanoState<ViewState> get state => _state;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
