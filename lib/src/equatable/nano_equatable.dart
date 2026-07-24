/// Base class providing value-based equality comparison for objects.
class NanoEquatable {
  /// Const constructor.
  const NanoEquatable();

  /// List of properties used to evaluate value equality.
  List<Object?> get props => [];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NanoEquatable) return false;
    if (runtimeType != other.runtimeType) return false;

    if (props.length != other.props.length) return false;
    for (int i = 0; i < props.length; i++) {
      if (props[i] != other.props[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(props);
}
