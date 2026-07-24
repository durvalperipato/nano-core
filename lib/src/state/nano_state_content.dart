import '../equatable/nano_equatable.dart';

/// The base class for state content that will be used by [NanoController].
///
/// Uses [NanoEquatable] to allow comparing states by value.
abstract class NanoStateContent extends NanoEquatable {
  /// Const constructor.
  const NanoStateContent();
}
