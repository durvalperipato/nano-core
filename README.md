# Nano Core

[![Pub Version](https://img.shields.io/pub/v/nano_core)](https://pub.dev/packages/nano_core)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Stable](https://img.shields.io/badge/Status-Stable-green.svg)](#)

A lightweight reactive architecture framework and design system toolkit for Flutter multiplatform applications.

## Features

- 🚀 **NanoScaffold**: Reactive base page scaffold supporting Web/Desktop headers, mobile AppBars, loading overlays, and error/warning/success toasts.
- ⚡ **NanoController & NanoState**: Clean, reactive state management built on `ChangeNotifier` and `ListenableBuilder`.
- 📊 **NanoViewState**: Base class for structured, immutable and equatable view/page state data models.
- 🛠️ **NanoCommand & NanoCommandBuilder**: Encapsulated async commands for user actions and operations.
- 🌐 **NanoHttpClient & NanoHttpResponse**: Standardized generic contract for decoupled HTTP communication, status codes, and helper extensions (`isSuccess`, `isClientError`, `isServerError`).
- 📦 **NanoRepository & NanoAdapter**: Automated generic CRUD repository layer with serialization/deserialization for domain entities.
- 🏷️ **NanoEntity & NanoEquatable**: Base domain entity with unique identification and value-based equality.
- 💉 **NanoInjections & NanoStatePage**: Dependency injection scoping with `GetIt` and page lifecycle binding.
- 🧩 **Design System Components**: Standalone reusable UI widgets such as `NanoLoadingOverlay` and `NanoToast`.
- 🖥️ **NanoDeviceType**: Real-time cross-platform environment and responsive viewport width inspection.

## Getting Started

Add `nano_core` to your `pubspec.yaml`:

```yaml
dependencies:
  nano_core: ^0.1.0-dev
```

## Quick Example

### 1. Domain Entity & Adapter
```dart
import 'package:nano_core/nano_core.dart';

class User extends NanoEntity<String> {
  final String name;
  const User({required super.id, required this.name});
}

class UserAdapter implements NanoAdapter<User> {
  const UserAdapter();

  @override
  User fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
  );

  @override
  Map<String, dynamic> toJson(User user) => {
    'id': user.id,
    'name': user.name,
  };
}

class UserRepository extends NanoRepository<User, String> {
  UserRepository(NanoHttpClient client)
      : super(
          client: client,
          endpoint: '/users',
          adapter: const UserAdapter(),
        );
}
```

### 2. View State, Controller & Injections
```dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';

// 1. Structured View State
class UsersViewState extends NanoViewState {
  final List<User> users;
  const UsersViewState({this.users = const []});

  @override
  List<Object?> get props => [users];
}

// 2. Reactive Controller
class MyController extends NanoController<UsersViewState> {
  final UserRepository repository;

  MyController({required this.repository});

  @override
  Future<void> init(String? id) async {
    await loadUsers();
  }

  Future<void> loadUsers() async {
    execute(() async {
      final users = await repository.getAll();
      return UsersViewState(users: users);
    });
  }
}

// 3. Page Injections Scope
class UsersInjections extends NanoInjections {
  UsersInjections() : super(scope: 'users');

  @override
  void binds(GetIt i) {
    i.registerLazySingleton<UserRepository>(
      () => UserRepository(i<NanoHttpClient>()),
    );
    i.registerFactory<MyController>(
      () => MyController(repository: i<UserRepository>()),
    );
  }
}

// 4. Page with NanoStatePage & NanoScaffold
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState
    extends NanoStatePage<UsersPage, MyController> {
  @override
  NanoInjections get injections => UsersInjections();

  @override
  Widget build(BuildContext context) {
    return NanoScaffold<UsersViewState, NanoMessageKey>(
      controller: controller,
      headerBuilder: (context, state) => AppBar(
        title: Text(
          state.data?.users.isNotEmpty == true
              ? 'Users (${state.data!.users.length})'
              : 'Users List',
        ),
      ),
      builder: (context, state) {
        final users = state.data?.users ?? [];
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(users[index].name),
            );
          },
        );
      },
    );
  }
}
```

### 3. HTTP Client Implementation with Dio (Optional)

`nano_core` remains 100% agnostic to third-party HTTP dependencies. To use **Dio** as your HTTP client, implement `NanoHttpClient` in your app:

```dart
import 'package:dio/dio.dart';
import 'package:nano_core/nano_core.dart';

class DioHttpClient implements NanoHttpClient {
  final Dio _dio;

  DioHttpClient(this._dio);

  @override
  Future<NanoHttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return NanoHttpResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<NanoHttpResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return NanoHttpResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<NanoHttpResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return NanoHttpResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<NanoHttpResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return NanoHttpResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<NanoHttpResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    return NanoHttpResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }
}
```

Register it once at app startup with `GetIt` / `NanoInjections`:

```dart
void main() {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
  GetIt.I.registerLazySingleton<NanoHttpClient>(() => DioHttpClient(dio));
  runApp(const MyApp());
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
