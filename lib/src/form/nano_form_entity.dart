import '../equatable/nano_equatable.dart';

/// An abstract base class for immutable form data entities.
///
/// Extends [NanoEquatable] to provide value-based equality comparisons.
abstract class NanoFormEntity extends NanoEquatable {
  /// Creates a [NanoFormEntity] instance.
  const NanoFormEntity();
}
