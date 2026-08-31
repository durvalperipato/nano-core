import '../state/nano_view_state.dart';
import 'nano_form_entity.dart';

/// An abstract base state representing an immutable view state containing a
/// strongly-typed [form] entity.
abstract class NanoFormState<F extends NanoFormEntity> extends NanoViewState {
  /// Creates a [NanoFormState] holding the given [form] entity.
  const NanoFormState({required this.form});

  /// The current immutable form data entity.
  final F form;

  @override
  List<Object?> get props => [form];
}
