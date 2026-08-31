/// Defines when form fields trigger and display validation errors.
enum NanoAutoValidateMode {
  /// Validates only when the form is submitted or validation is manually
  /// invoked (default and cleanest behavior).
  onSubmit,

  /// Validates in real time as the user types or interacts with the field.
  onUserInteraction,

  /// Validates when the field loses input focus (blur).
  onFocusLost,

  /// Always validates on every rebuild or state transition.
  always,

  /// Auto-validation is completely disabled; only manual `validate()` calls
  /// evaluate rules.
  disabled,
}
