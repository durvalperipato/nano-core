# Nano Core

[![Pub Version](https://img.shields.io/pub/v/nano_core)](https://pub.dev/packages/nano_core)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Stable](https://img.shields.io/badge/Status-Stable-green.svg)](#)

A lightweight reactive architecture framework and design system toolkit for Flutter multiplatform applications.

## Features

- 📱 **NanoApp**: Zero-boilerplate root application widget automatically configuring `NanoRouter`, `MaterialApp`, themes, and localizations.
- 🧭 **NanoRouter & Declarative Routes**: Intuitive zero-dependency declarative router supporting public routes (`NanoRoute`), custom animated transitions (`NanoAnimatedRoute`), route groups (`NanoGroupRoute`), typed sub-routes (`NanoDetailsRoute<T>`), access-guarded routes (`NanoProtectedRoute`), and redirects (`NanoRedirectRoute`).
- 🔭 **NanoRouteObserver**: Granular navigation observer for screen tracking, Firebase Analytics, Datadog, breadcrumbs, and route lifecycle telemetry.
- 🚀 **NanoScaffold & NanoStateObservable**: Decoupled reactive base page scaffold supporting Web/Desktop headers, mobile AppBars, loading overlays, toasts, and universal state observation (`NanoController`, BLoC, Cubit, MobX adapters).
- ⚡ **NanoController & NanoState**: Clean, reactive state management built on `ChangeNotifier` and `ListenableBuilder`.
- 📊 **NanoViewState**: Base class for structured, immutable and equatable view/page state data models.
- 🛠️ **NanoCommand & NanoCommandBuilder**: Encapsulated async commands for user actions and operations.
- 🌐 **NanoHttpClient & NanoHttpInterceptor**: Standardized generic contract for decoupled HTTP communication, request/response interceptors (JWT injection, refresh tokens), built-in traffic logging (`NanoHttpLogInterceptor`), and helper extensions (`isSuccess`, `isClientError`, `isServerError`).
- 📦 **NanoRepository & NanoAdapter**: Automated generic CRUD repository layer with serialization/deserialization for domain entities.
- 🏷️ **NanoEntity & NanoEquatable**: Base domain entity with unique identification and value-based equality.
- 🪵 **NanoLogger**: Central structured console logger with ANSI styling, severity levels (`debug`, `info`, `success`, `warning`, `error`, `http`), method context tracking, data payloads, and telemetry hooks.
- 💉 **NanoInjections & NanoStatePage**: Dependency injection scoping with `GetIt`, modular composition, and page lifecycle binding.
- 🧩 **Design System Components**: Standalone reusable UI widgets such as `NanoLoadingOverlay` and `NanoToast`.
- 🖥️ **NanoDeviceType**: Real-time cross-platform environment and responsive viewport width inspection.

## Getting Started

Add `nano_core` to your `pubspec.yaml`:

```yaml
dependencies:
  nano_core: ^0.2.0
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
class UsersState extends NanoViewState {
  final List<User> users;
  const UsersState({this.users = const []});

  @override
  List<Object?> get props => [users];
}

// 2. Reactive Controller
class MyController extends NanoController<UsersState> {
  final UserRepository repository;

  MyController({required this.repository});

  @override
  Future<void> init(String? id) async {
    await loadUsers();
  }

  Future<void> loadUsers() async {
    execute(() async {
      final users = await repository.getAll();
      return UsersState(users: users);
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
    return NanoScaffold<UsersState, NanoMessageKey>(
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

Register it with interceptors at app startup with `GetIt` / `NanoInjections`:

```dart
void main() {
  final client = DioHttpClient(Dio(BaseOptions(baseUrl: 'https://api.example.com')));
  
  // Add traffic logging or custom authentication interceptors:
  client.addInterceptor(const NanoHttpLogInterceptor());
  
  GetIt.I.registerLazySingleton<NanoHttpClient>(() => client);
  runApp(const MyApp());
}
```

### 4. Declarative Routing with NanoRouter, Observers & NanoApp

Define all application routes and analytics observers in a single declarative router file:

```dart
import 'package:nano_core/nano_core.dart';

final appRouter = NanoRouter(
  initialRoute: '/', // Optional: defaults to '/'
  observers: [
    // 🔭 Track screens automatically with Firebase Analytics / Datadog:
    NanoRouteObserver(
      onRouteChange: (from, to, args) {
        debugPrint('Navigated from: $from -> to: $to');
      },
    ),
  ],
  routes: [
    // Public dashboard route with smooth fade transition:
    NanoAnimatedRoute.fade(
      name: 'showcase',
      path: '/',
      builder: (context, args) => const ShowcasePage(),
    ),

    // Users list with nested typed detail route:
    NanoRoute(
      name: 'users',
      path: '/users',
      builder: (context, args) => const UsersPage(),
      routes: [
        // Sub-route: /users/detail with automatic argument typing
        NanoDetailsRoute<User>(
          name: 'user_detail',
          builder: (context, user) => UserDetailPage(user: user),
        ),
      ],
    ),

    // Protected area with route guard wrapping admin routes:
    NanoProtectedRoute(
      hasAccess: (context, args) => AuthService.isAdmin,
      redirectTo: 'login',
      routes: [
        NanoGroupRoute(
          path: '/admin',
          routes: [
            NanoRoute(
              name: 'admin',
              path: '/panel',
              builder: (context, args) => const AdminPage(),
            ),
          ],
        ),
      ],
    ),

    // Redirect / Alias route:
    NanoRedirectRoute(
      path: '/home',
      redirectTo: 'showcase',
    ),
  ],
);
```

Then plug it directly into `NanoApp` in `main.dart`:

```dart
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NanoApp(
      title: 'My Nano App',
      router: appRouter, // 🧭 Configures navigatorKey, initialRoute, and onGenerateRoute
      theme: AppTheme.darkTheme,
    );
  }
}
```

#### Navigating anywhere:
```dart
// Navigate by route name:
context.toNamed('user_detail', arguments: user);

// Navigate by path:
context.toNamed('/users/detail', arguments: user);

// Replace current screen:
context.toReplacementNamed('login');

// Pop screen:
context.back();
```

### 5. Structured Logging with NanoLogger

Log formatted, color-coded, and tagged events with method tracking and data inspection:

```dart
import 'package:nano_core/nano_core.dart';

// Info with method tracking and data payload:
NanoLogger.info(
  'User authenticated successfully',
  tag: 'AuthService',
  method: 'loginWithEmail',
  data: {'userId': '123', 'role': 'admin'},
);

// Success notification (using the short alias NanoLog or NLog):
NanoLog.success('Cache synchronized', tag: 'UserRepository');
NLog.info('Shortest syntax!');

// HTTP event with httpMethod and statusCode:
NLog.http(
  '/users',
  httpMethod: 'GET',
  statusCode: 200,
  tag: 'NanoHttp',
  method: 'getUsers',
  data: {'count': 2},
);

// Error reporting with exception, statusCode and stack trace:
NanoLog.error(
  'Failed to fetch user profile',
  statusCode: 404,
  tag: 'UserRepository',
  method: 'getById',
  data: {'id': '123'},
  error: exception,
  stackTrace: stackTrace,
);
```

> **Tip:** You can use `NanoLogger`, `NanoLog`, or `NLog` interchangeably as concise aliases.

Hook errors directly into Crashlytics or Sentry:
```dart
NanoLogger.onError = (entry) {
  FirebaseCrashlytics.instance.recordError(
    entry.error,
    entry.stackTrace,
    reason: entry.message,
  );
};
```

### 6. Universal State Management (BLoC, Cubit, MobX, GetX, Signals)

`NanoScaffold` can observe any external state management library via the lightweight `NanoStateObservable` contract or using out-of-the-box generic adapters:

#### ⚡ Option A: Out-of-the-Box Generic Adapters (Zero Boilerplate)

```dart
// 1. Any Stream (BLoC, Cubit, RxDart, WebSockets):
final blocController = NanoStreamAdapter<UserState, BlocState>(
  stream: userBloc.stream,
  initialState: InitialState(),
  mapper: (blocState) => switch (blocState) {
    UserLoading() => LoadingState(),
    UserSuccess(:final user) => SuccessState(data: user),
    _ => InitialState(),
  },
);

// 2. Any Listenable (MobX, Signals, ValueNotifier, Provider):
final storeController = NanoListenableAdapter<UserState>(
  listenable: userStore,
  stateGetter: () => userStore.isBusy
      ? LoadingState()
      : SuccessState(data: userStore.user),
);

// Use directly in NanoScaffold:
NanoScaffold(
  controller: blocController,
  builder: (context, state) => Text('User: ${state.data?.name}'),
);
```

#### 🛠️ Option B: Custom Class Implementation

<details>
<summary><b>1. BLoC / Cubit Class Adapter</b></summary>

```dart
class UserCubitAdapter extends ChangeNotifier
    implements NanoStateObservable<UserState> {
  final UserCubit cubit;
  late final StreamSubscription _sub;

  UserCubitAdapter(this.cubit) {
    _sub = cubit.stream.listen((_) => notifyListeners());
  }

  @override
  NanoState<UserState> get state => switch (cubit.state) {
    UserLoading() => LoadingState(),
    UserSuccess(:final user) => SuccessState(data: user),
    UserError() => ErrorState(),
    _ => InitialState(),
  };

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
```
</details>

<details>
<summary><b>2. MobX Class Adapter</b></summary>

```dart
class UserMobxAdapter extends ChangeNotifier
    implements NanoStateObservable<UserState> {
  final UserStore store;
  late final ReactionDisposer _disposer;

  UserMobxAdapter(this.store) {
    _disposer = autorun((_) => notifyListeners());
  }

  @override
  NanoState<UserState> get state {
    if (store.isLoading) return LoadingState();
    if (store.user != null) return SuccessState(data: store.user!);
    return InitialState();
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }
}
```
</details>

<details>
<summary><b>3. GetX Class Adapter</b></summary>

```dart
class UserGetxAdapter extends ChangeNotifier
    implements NanoStateObservable<UserState> {
  final UserController getxController;
  late final Worker _worker;

  UserGetxAdapter(this.getxController) {
    _worker = ever(getxController.stateRx, (_) => notifyListeners());
  }

  @override
  NanoState<UserState> get state => getxController.stateRx.value;

  @override
  void dispose() {
    _worker.dispose();
    super.dispose();
  }
}
```
</details>

<details>
<summary><b>4. Signals / ValueNotifier Class Adapter</b></summary>

```dart
class UserSignalsAdapter extends ChangeNotifier
    implements NanoStateObservable<UserState> {
  final Signal<NanoState<UserState>> signalState;
  late final VoidCallback _cleanup;

  UserSignalsAdapter(this.signalState) {
    _cleanup = effect(() {
      signalState.value; // register dependency
      notifyListeners();
    });
  }

  @override
  NanoState<UserState> get state => signalState.value;

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}
```
</details>

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
