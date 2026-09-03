import '../equatable/nano_equatable.dart';

/// An abstract base class for structured View/Page state data.
///
/// Extends [NanoEquatable] to enforce immutable, value-equatable state models
/// for all [NanoController] implementations.
abstract class NanoViewState extends NanoEquatable {
  /// Creates a [NanoViewState] instance.
  const NanoViewState();

  /// List of properties used to evaluate value equality.
  ///
  /// Subclasses must explicitly override this getter to declare their state
  /// fields for precise widget rebuild filtering and equatable comparisons.
  @override
  List<Object?> get props;
}
