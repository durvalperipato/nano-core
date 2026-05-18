import 'package:nano_core/equatable/nano_equatable.dart';

/// The base class for state content that will be used by [NanoController].
///
/// Extends [NanoEquatable] to allow comparing states by value.
abstract class NanoStateContent extends NanoEquatable {
  /// Const constructor.
  const NanoStateContent();
}
