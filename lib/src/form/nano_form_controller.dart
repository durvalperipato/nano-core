import 'dart:async';
import 'package:flutter/material.dart';
import '../controller/nano_controller.dart';
import 'nano_form_entity.dart';
import 'nano_form_state.dart';

/// A specialized [NanoController] for form workflows managing an immutable
/// [NanoFormState] holding a [NanoFormEntity] with integrated form key
/// validation and lifecycle management.
abstract class NanoFormController<
  ViewState extends NanoFormState<FormEntity>,
  FormEntity extends NanoFormEntity
>
    extends NanoController<ViewState> {
  /// Creates a [NanoFormController] with required initial view state.
  NanoFormController({required super.initialState})
    : _initialState = initialState;

  final ViewState _initialState;

  @override
  Future<void> init(String? id) async {}

  /// Global form key managing the surrounding [NanoForm] or [Form] state.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Convenience getter for the active form entity in state.
  FormEntity? get currentForm => viewState.form;

  /// Validates all form fields associated with [formKey].
  ///
  /// Returns `true` if all fields are valid, `false` otherwise.
  bool validate() => formKey.currentState?.validate() ?? false;

  /// Validates the form and executes [onValid] only when valid.
  ///
  /// If validation fails, [onInvalid] is invoked instead.
  Future<void> submit(
    FutureOr<void> Function(FormEntity form) onValid, {
    void Function()? onInvalid,
  }) async {
    if (validate()) {
      final form = currentForm;
      if (form != null) {
        await onValid(form);
      }
    } else {
      onInvalid?.call();
    }
  }

  /// Resets the form state and visual validation errors back to initial values.
  void reset() {
    formKey.currentState?.reset();
    emitLoaded(_initialState);
  }

  /// Updates the form view state and emits the new state.
  void updateForm(ViewState Function(ViewState currentState) stateUpdater) {
    emitLoaded(stateUpdater(viewState));
  }
}
