# Nano Core

A lightweight, modular core library for Flutter and Dart projects, designed to provide fundamental building blocks for state management, dependency injection, and value-based equality.

## Features

- **NanoController**: A base class for state management utilizing `StreamController` to broadcast state changes.
- **NanoEquatable**: A simplified base class for comparing objects by their properties rather than their instance identity.
- **NanoInjections**: An abstraction over `get_it` to easily manage and push/drop dependency injection scopes.
- **NanoStateContent**: A base class for defining your application states, integrating seamlessly with `NanoController` and `NanoEquatable`.

## Getting Started

Add `nano_core` to your `pubspec.yaml` dependencies.

### State Management

Create your states extending `NanoStateContent`:

```dart
class MyState extends NanoStateContent {
  final int count;

  const MyState(this.count);

  @override
  List<Object?> get props => [count];
}
```

Create your controller extending `NanoController`:

```dart
class MyController extends NanoController<MyState> {
  MyController() : super(initialState: const MyState(0));

  void increment() {
    emit(MyState(state.count + 1));
  }
}
```

### Dependency Injection

Manage your scopes extending `NanoInjections`:

```dart
class AuthInjections extends NanoInjections {
  AuthInjections() : super(scope: 'auth_scope');

  @override
  void binds(GetIt i) {
    i.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  }
}
```

Use `initScope()` to start the scope and `dropScope()` when disposing of the module.

## Documentation and Comments

This repository follows the rule of **NO inline code comments** (`// comment`). Instead, all public APIs, classes, and methods use **Dart documentation comments** (`/// doc comment`) in English. This is to adhere to the Flutter team's best practices, where inline comments are considered an anti-pattern.
