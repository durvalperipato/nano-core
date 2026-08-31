import 'package:flutter/foundation.dart';
import 'nano_state.dart';
import 'nano_view_state.dart';

/// An abstract interface contract representing any state holder or reactive
/// stream that can be observed by [NanoScaffold].
///
/// This allows [NanoScaffold] to remain decoupled from concrete controller
/// implementations, seamlessly supporting [NanoController], BLoC, Cubit,
/// MobX, Signals, or custom [ChangeNotifier] state adapters.
abstract interface class NanoStateObservable<T extends NanoViewState>
    implements Listenable {
  /// The current [NanoState] snapshot.
  NanoState<T> get state;
}
