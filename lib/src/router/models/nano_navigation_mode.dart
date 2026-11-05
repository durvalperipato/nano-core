/// Defines the transition mode for a reactive navigation event in [nano_core].
enum NanoNavigationMode {
  /// Pushes a new route onto the navigation stack.
  push,

  /// Replaces the current route with a new one.
  replace,

  /// Pops the current route from the navigation stack.
  pop,

  /// Removes all existing routes and establishes the new route as the root.
  clearStack,
}

