import 'package:flutter/material.dart';
import '../form/nano_form_controller.dart';

/// A reactive container widget that binds a [NanoFormController.formKey] to a
/// Flutter [Form] widget for seamless form validation and lifecycle management.
class NanoForm extends StatelessWidget {
  /// Creates a [NanoForm] wrapper widget.
  const NanoForm({
    required this.controller,
    required this.child,
    this.autovalidateMode,
    this.onChanged,
    this.canPop,
    this.onPopInvokedWithResult,
    super.key,
  });

  /// The controller managing this form.
  final NanoFormController controller;

  /// The widget subtree containing form fields.
  final Widget child;

  /// Optional autovalidate mode for all fields inside this form.
  final AutovalidateMode? autovalidateMode;

  /// Callback invoked whenever any field within the form changes.
  final VoidCallback? onChanged;

  /// Whether the user can pop/navigate back when form is active.
  final bool? canPop;

  /// Callback invoked when a pop is attempted.
  final PopInvokedWithResultCallback<dynamic>? onPopInvokedWithResult;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: child,
    );
  }
}
