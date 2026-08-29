import '../equatable/nano_equatable.dart';

/// Base class for domain entities with a unique identifier.
///
/// Extends [NanoEquatable] to support value equality by default using the [id].
abstract class NanoEntity<ID> extends NanoEquatable {
  /// Creates a [NanoEntity] instance with the given [id].
  const NanoEntity({required this.id});

  /// The unique identifier of the entity.
  final ID id;

  @override
  List<Object?> get props => [id];
}
