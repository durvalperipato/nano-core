import '../../equatable/nano_equatable.dart';
import 'nano_navigation_mode.dart';

/// Represents a one-shot reactive navigation event emitted by a controller.
class NanoNavigationEvent extends NanoEquatable {
  /// Creates a [NanoNavigationEvent].
  const NanoNavigationEvent({
    required this.routeName,
    this.mode = NanoNavigationMode.push,
    this.args,
  });

  /// The target route name or path.
  final String routeName;

  /// The navigation transition mode.
  final NanoNavigationMode mode;

  /// Optional arguments delivered to the route.
  final Object? args;

  @override
  List<Object?> get props => [routeName, mode, args];
}

