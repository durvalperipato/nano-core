import 'package:flutter/material.dart';
import '../form/nano_autovalidate_mode.dart';
import '../form/nano_validator.dart';

/// A Material text field component supporting value synchronization,
/// validation with [BuildContext] internationalization, auto-validation modes,
/// password visibility toggling, and native [Form] integration.
class NanoTextField extends StatefulWidget {
  /// Creates a [NanoTextField] widget.
  const NanoTextField({
    this.value,
    this.onChanged,
    this.validators = const [],
    this.autoValidateMode = NanoAutoValidateMode.onSubmit,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.decoration,
    super.key,
  });

  /// The current text value for this field.
  final String? value;

  /// Callback invoked whenever the input text changes.
  final ValueChanged<String>? onChanged;

  /// List of validation functions evaluated on this field.
  final List<NanoValidatorFunction<String>> validators;

  /// The autovalidation trigger mode for this field.
  final NanoAutoValidateMode autoValidateMode;

  /// Label text displayed above or inside the field.
  final String? label;

  /// Hint placeholder text.
  final String? hint;

  /// Optional prefix icon widget.
  final Widget? prefixIcon;

  /// Optional suffix icon widget.
  final Widget? suffixIcon;

  /// Whether this field is a password (enables toggleable obscure text).
  final bool isPassword;

  /// Whether the field is interactive and editable.
  final bool enabled;

  /// Whether to automatically focus this field when rendered.
  final bool autofocus;

  /// Maximum number of lines. Defaults to 1.
  final int maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Keyboard type for input formatting.
  final TextInputType? keyboardType;

  /// Action button for the software keyboard.
  final TextInputAction? textInputAction;

  /// Callback invoked when the user submits from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Custom InputDecoration overriding default styling.
  final InputDecoration? decoration;

  @override
  State<NanoTextField> createState() => _NanoTextFieldState();
}

class _NanoTextFieldState extends State<NanoTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _obscureText = false;
  FormFieldState<String>? _fieldState;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _controller = TextEditingController(text: widget.value ?? '');
    _focusNode = FocusNode();

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant NanoTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.value!,
        selection: TextSelection.collapsed(offset: widget.value!.length),
      );
      _fieldState?.didChange(widget.value);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      if (widget.autoValidateMode == NanoAutoValidateMode.onFocusLost) {
        _fieldState?.validate();
      }
    }
  }

  AutovalidateMode _mapAutovalidateMode(NanoAutoValidateMode mode) {
    return switch (mode) {
      NanoAutoValidateMode.always => AutovalidateMode.always,
      NanoAutoValidateMode.onUserInteraction =>
        AutovalidateMode.onUserInteraction,
      NanoAutoValidateMode.onSubmit ||
      NanoAutoValidateMode.onFocusLost ||
      NanoAutoValidateMode.disabled =>
        AutovalidateMode.disabled,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.value ?? '',
      autovalidateMode: _mapAutovalidateMode(widget.autoValidateMode),
      validator: (_) {
        for (final validator in widget.validators) {
          final err = validator(_controller.text);
          if (err != null) {
            return NanoValidator.resolveMessage(err, context);
          }
        }
        return null;
      },
      builder: (fieldState) {
        _fieldState = fieldState;

        Widget? effectiveSuffixIcon = widget.suffixIcon;
        if (widget.isPassword) {
          effectiveSuffixIcon = IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          );
        }

        final defaultDecoration = InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: fieldState.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: effectiveSuffixIcon,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );

        return TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          obscureText: _obscureText,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          onChanged: (text) {
            fieldState.didChange(text);
            widget.onChanged?.call(text);
          },
          decoration: widget.decoration != null
              ? widget.decoration!.copyWith(
                  errorText: fieldState.errorText,
                  suffixIcon:
                      effectiveSuffixIcon ?? widget.decoration!.suffixIcon,
                )
              : defaultDecoration,
        );
      },
    );
  }
}
