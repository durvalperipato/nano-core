import 'dart:async';
import 'package:flutter/material.dart';
import '../controller/nano_controller.dart';
import '../state/nano_state.dart';
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
  /// Creates a [NanoFormController] with optional initial view state.
  NanoFormController({ViewState? initialData}) : _initialData = initialData {
    if (initialData != null) {
      state = SuccessState<ViewState>(initialData);
    }
  }

  final ViewState? _initialData;

  /// Global form key managing the surrounding [NanoForm] or [Form] state.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Convenience getter for the active form entity in state.
  FormEntity? get currentForm => state.data?.form;

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
    if (_initialData != null) {
      emit(SuccessState<ViewState>(_initialData));
    }
  }

  /// Updates the form view state and emits the new state.
  void updateForm(ViewState Function(ViewState currentState) stateUpdater) {
    final current = state.data;
    if (current != null) {
      emit(SuccessState<ViewState>(stateUpdater(current)));
    }
  }
}
