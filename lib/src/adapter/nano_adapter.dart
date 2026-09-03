import 'nano_read_adapter.dart';
import 'nano_write_adapter.dart';

/// A bidirectional contract combining [NanoReadAdapter] and [NanoWriteAdapter].
///
/// Implement or extend this adapter for entities that require both
/// serialization and deserialization.
abstract class NanoAdapter<Entity> extends NanoReadAdapter<Entity>
    with NanoWriteAdapter<Entity> {
  /// Const constructor allowing subclasses to be const.
  const NanoAdapter();
}
