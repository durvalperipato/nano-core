# Nano Core

[![Pub Version](https://img.shields.io/pub/v/nano_core)](https://pub.dev/packages/nano_core)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Donate-orange.svg?logo=buy-me-a-coffee)](https://buymeacoffee.com/nanodevs)
[![Status: Stable](https://img.shields.io/badge/Status-Stable-green.svg)](#)

A lightweight reactive architecture framework and design system toolkit for Flutter multiplatform applications.

## Features

- 📱 [**NanoApp**](#4-declarative-routing-with-nanorouter-observers--nanoapp): Zero-boilerplate root application widget automatically configuring `NanoRouter`, `MaterialApp`, themes, and localizations.

- 🧭 [**NanoRouter & Declarative Routes (NanoRouteBase)**](#4-declarative-routing-with-nanorouter-observers--nanoapp): Intuitive zero-dependency declarative router supporting polymorphic route hierarchies (`NanoRouteBase`), standard routes (`NanoRoute`), persistent tab shells (`NanoShellRoute`), animated transitions (`NanoAnimatedRoute`), route groups (`NanoGroupRoute`), typed sub-routes (`NanoDetailsRoute<Args>`), access-guarded routes (`NanoProtectedRoute`), and redirects (`NanoRedirectRoute`).

- 🔭 [**NanoRouteObserver**](#4-declarative-routing-with-nanorouter-observers--nanoapp): Granular navigation observer for screen tracking, Firebase Analytics, Datadog, breadcrumbs, and route lifecycle telemetry.

- 🚀 [**NanoScaffold & NanoStateObservable**](#6-universal-state-management-bloc-cubit-mobx-getx-signals): Decoupled reactive base page scaffold supporting Web/Desktop headers, mobile AppBars, drawers, footers, customizable floating action buttons with positioning (`floatingActionButtonLocation`), loading overlays, toasts, fallback messages (`defaultErrorMessage`, `defaultWarningMessage`), and universal state observation (`NanoController`, BLoC, Cubit, MobX adapters).

- 🐚 [**NanoShellScaffold, NanoShellTab & NanoShellSubView**](#5-persistent-multi-tab-navigation-nanoshellroute--nanoshellscaffold): Persistent navigation shell scaffold managing primary tabs with keep-alive (`maintainState`), optional contextual sub-views (e.g. notifications, search overlays), persistent floating action buttons, drawers, and automatic back-gesture handling (`enablePopScope`).

- ⚡ [**NanoController & NanoState**](#2-view-state-controller--injections): Clean, reactive state management built on `ChangeNotifier` and `ListenableBuilder`.

- 📊 [**NanoViewState**](#2-view-state-controller--injections): Base class for structured, immutable and equatable view/page state data models.

- 🛠️ [**NanoCommand & NanoCommandBuilder**](#11-encapsulated-commands-nanocommand--nanocommandbuilder): Encapsulated async commands for user actions and operations.

- 🌐 [**NanoHttpClient & NanoHttpInterceptor**](#3-http-client-implementation-with-dio-optional): Standardized generic contract for decoupled HTTP communication, request/response interceptors (JWT injection, refresh tokens), built-in traffic logging (`NanoHttpLogInterceptor`), and helper extensions (`isSuccess`, `isClientError`, `isServerError`).

- 📦 [**NanoRepository, NanoSearchRepository & NanoQueryAdapter**](#6-type-safe-search-query-adapters--pagination-with-nanopaginator): Automated generic CRUD repository layer, type-safe search query serialization, and domain model adapters.

- 📄 [**Pagination & NanoPaginator**](#4-automatic-infinite-scroll-mobile-or-page-navigation-bar-web): Pluggable strategies (`NanoOffsetPagination`, `NanoCursorPagination`), reactive controller (`NanoPaginator`), automatic infinite scrolling widget (`NanoPaginatedListView`), and customizable navigation bar (`NanoPaginationBar`).

- ⚡ [**NanoCache & Smart Caching**](#4-instantaneous-caching-0ms-latency--offline-fallback): Zero-dependency in-memory caching (`NanoMemoryCache`) with configurable policies (`cacheFirst`, `networkFirst`, `networkOnly`, `cacheOnly`), TTL expiration, and automatic invalidation on CRUD mutations.

- 🛡️ [**Functional Results (NanoResult)**](#6-type-safe-functional-results-with-nanoresult): Modern Dart 3 `sealed class` hierarchy (`NanoSuccess`, `NanoFailure`) with compile-time pattern matching, `fold`, `map`, and `runAsync` safe execution.

- 📝 [**NanoForm & Validators**](#7-reactive-forms-internationalized-validators--nanotextfield): Strongly-typed form models, automatic field disposal, `BuildContext` i18n support, and reactive `NanoTextField` component.

- 🏷️ [**NanoEntity & NanoEquatable**](#1-domain-entity--adapter): Base domain entity with unique identification and value-based equality.

- 🔐 [**NanoOAuth & NanoPkce**](#7-modern-oauth-20--pkce-nanooauth--nanopkce): Zero-dependency OAuth 2.0 PKCE toolkit (RFC 7636) with built-in pure-Dart SHA-256 for secure authorization URLs, code challenge generation, token exchange payloads, and anti-CSRF callback parsing.

- 🔑 [**NanoAuthRepository**](#6-authentication--session-repository-nanoauthrepository): Pure token and session lifecycle management with symmetrical storage keys, automatic token storage, and session contracts.

- 🪵 [**NanoLogger & NanoLogFilter**](#8-structured-logging-with-nanologger--nanologfilter): Granular structured console logger with type-safe level filtering (`NanoLogFilter`), ANSI styling, method context tracking, and telemetry hooks.

- 💉 [**NanoInjections, NanoDefaultInjections & NanoStatePage**](#13-dependency-injection-nanoinjections-async-binds--nanodefaultinjections): Dependency injection scoping with `GetIt`, default framework services registration (`NanoDefaultInjections.init`), modular composition, and page lifecycle binding.

- ⏱️ [**NanoDebouncer**](#9-debounced-search-inputs): Flexible async execution delay for search inputs, autocomplete, and live filters with native `NanoTextField(debounceDuration: ...)` support.

- 🌐 [**NanoConnectivity**](#10-reactive-connectivity--offline-handling): Zero-dependency cross-platform reactive network monitor (`NanoConnectivity`, `NanoConnectivityStatus`) with seamless `NanoScaffold(connectivityBuilder: ...)` integration.

- 🧩 [**Design System Components**](#7-reactive-forms-internationalized-validators--nanotextfield): Standalone reusable UI widgets such as `NanoLoadingOverlay`, `NanoToast`, `NanoPaginatedListView`, `NanoPaginationBar`, and `NanoTextField`.

- 🖥️ [**NanoDeviceType**](#8-environment--build-modes-nanoenvironment--nanoenv): Real-time cross-platform environment and responsive viewport width inspection.

## Getting Started

Add `nano_core` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  nano_core: ^0.9.0
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
  User fromMap(Map<String, dynamic> map) => User(
    id: map['id'] as String,
    name: map['name'] as String,
  );

  @override
  Map<String, dynamic> toMap(User user) => {
    'id': user.id,
    'name': user.name,
  };
}

class UserRepository extends NanoRepository<User, String> {
  UserRepository({
    super.endpoint = '/users',
    super.adapter = const UserAdapter(),
    super.client,
  });
}

// Type-Safe Search with NanoSearchRepository:
class UserFilter {
  final String? role;
  final int page;
  const UserFilter({this.role, this.page = 1});
}

class UserFilterAdapter extends NanoWriteAdapter<UserFilter> {
  const UserFilterAdapter();

  @override
  Map<String, dynamic> toMap(UserFilter query) {
    return <String, dynamic>{}
        .add('page', query.page)
        .addIf('role', query.role);
  }
}

class UserSearchRepository
    extends NanoSearchRepository<User, String, UserFilter> {
  UserSearchRepository({
    super.endpoint = '/users',
    super.adapter = const UserAdapter(),
    super.queryAdapter = const UserFilterAdapter(),
    super.client,
  });
}

// Search with type-safe query parameters:
// final results = await userSearchRepository.searchAll(const UserFilter(role: 'admin'));
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

  MyController({
    required this.repository,
    super.initialState = const UsersState(),
  });

  @override
  Future<void> init(String? id) async {
    await loadUsers();
  }

  Future<void> loadUsers() async {
    emitLoading(); // Style 1: Direct convenience method
    try {
      final users = await repository.getAll();
      emitLoaded(UsersState(users: users));
    } catch (_) {
      emitError();
    }
  }

  // 💡 3 Flexible Ways to Emit State in NanoController:
  // 1. Direct Helper:  emitLoaded(myState), emitLoading(), emitSuccess(key: ...), emitError(key: ...), emitCustom(myPayload)
  // 2. Fluent State:   emit(state.toLoaded(myState)), emit(state.toLoading()), emit(state.toCustom(myPayload))
  // 3. Explicit Class: emit(LoadedState(myState)), emit(const LoadingState()), emit(CustomState(myPayload))
}

// 3. Page Injections Scope
class UsersInjections extends NanoInjections {
  const UsersInjections() : super(scope: 'users');

  @override
  void binds(GetIt i) {
    // 1. Initialize default core framework services:
    NanoDefaultInjections.init(i, client: DioHttpClient(Dio()));

    // 2. Register repository (client is automatically injected via GetIt!):
    i.registerLazySingleton<UserRepository>(() => UserRepository());

    // 3. Register page controller:
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
  NanoInjections get injections => const UsersInjections();

  @override
  Widget build(BuildContext context) {
    return NanoScaffold<UsersState, NanoMessageKey>(
      controller: controller,
      defaultErrorMessage: 'An unexpected error occurred',
      header: (context, state) => AppBar(
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

class DioHttpClient extends NanoHttpClient {
  final Dio _dio;

  DioHttpClient(this._dio, {super.interceptors});

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

### 5. Persistent Multi-Tab Navigation (NanoShellRoute & NanoShellScaffold)

Zero-dependency persistent shell scaffold managing multi-tab apps with state preservation (`maintainState`), contextual sub-views (e.g. notifications/search overlays), dynamic floating action bars, and system back gesture interception (`enablePopScope`).

`nano_core` gives you the flexibility to choose between two elegant approaches:

#### Approach A: Declarative Shell in `NanoRouter` via `NanoShellRoute` (Recommended)
Register persistent shells cleanly in `NanoRouter` via `shells:` (or `routes:`), delegating layout to your page widget without leaking UI scaffolding into router tables:

```dart
enum AppTab { home, favorites, profile, settings }
enum AppSubView { searchOverlay }

final appRouter = NanoRouter(
  initialRoute: '/home',
  routes: [
    NanoRoute(path: '/login', builder: (_, __) => const LoginPage()),
  ],
  shells: [
    NanoShellRoute<AppTab, AppSubView>(
      path: '/home',
      name: 'home',
      initialTab: AppTab.home,
      builder: (context, controller, body) => HomePage(
        body: body,
        controller: controller,
      ),
      tabs: [
        NanoShellTab(value: AppTab.home, builder: (_) => const FeedPage()),
        NanoShellTab(value: AppTab.favorites, builder: (_) => const FavoritesPage()),
        NanoShellTab(value: AppTab.profile, builder: (_) => const ProfilePage()),
        NanoShellTab(value: AppTab.settings, builder: (_) => const SettingsPage()),
      ],
      subViews: [
        NanoShellSubView(
          id: AppSubView.searchOverlay,
          builder: (_) => const SearchOverlayPage(),
        ),
      ],
    ),
  ],
);
```

Where your `HomePage` is a clean, encapsulated widget:

```dart
class HomePage extends StatelessWidget {
  final Widget body;
  final NanoShellController<AppTab, AppSubView> controller;

  const HomePage({required this.body, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: controller.isShowingSubView
          ? null
          : MyFloatingNavBar(
              activeTab: controller.currentTab,
              onTabSelected: controller.selectTab,
            ),
      body: body,
    );
  }
}
```

#### Approach B: Modular Page Widget via `NanoShellScaffold`
Prefer building a standalone widget page? Use `NanoShellScaffold` directly:

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NanoShellScaffold<AppTab, AppSubView>(
      initialTab: AppTab.home,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (context, controller) {
        if (controller.isShowingSubView) return null;
        return MyFloatingNavBar(
          activeTab: controller.currentTab,
          onTabSelected: controller.selectTab,
        );
      },
      tabs: [
        NanoShellTab(value: AppTab.home, builder: (_) => const FeedPage()),
        NanoShellTab(value: AppTab.favorites, builder: (_) => const FavoritesPage()),
        NanoShellTab(value: AppTab.profile, builder: (_) => const ProfilePage()),
        NanoShellTab(value: AppTab.settings, builder: (_) => const SettingsPage()),
      ],
      subViews: [
        NanoShellSubView(
          id: AppSubView.searchOverlay,
          builder: (_) => const SearchOverlayPage(),
        ),
      ],
    );
  }
}
```

#### Fluid Shell Navigation anywhere via `BuildContext`:
```dart
// Switch primary tab fluidly:
context.shell.selectTab(AppTab.favorites);

// Open contextual sub-view:
context.shell.openSubView(AppSubView.searchOverlay);

// Close active sub-view:
context.shell.closeSubView();

// Check if a sub-view is open:
if (context.shell.isSubViewOpen()) { ... }

// Read active tab:
final currentTab = context.shell.currentTab<AppTab>();
```

#### Guarding Shell Routes with `NanoProtectedRoute`:
Because `NanoRoute` and `NanoShellRoute` extend `NanoRouteBase`, you can guard entire multi-tab shells directly with `NanoProtectedRoute`:

```dart
final appRouter = NanoRouter(
  initialRoute: '/home',
  routes: [
    NanoRoute(path: '/login', builder: (_, __) => const LoginPage()),

    // Guards the persistent shell and all its tabs:
    NanoProtectedRoute(
      hasAccess: (context, args) => AuthService.isAuthenticated,
      redirectTo: '/login',
      routes: [
        NanoShellRoute<AppTab, AppSubView>(
          path: '/home',
          builder: (context, controller, body) => HomePage(
            body: body,
            controller: controller,
          ),
          tabs: [
            NanoShellTab(value: AppTab.home, builder: (_) => const FeedPage()),
            NanoShellTab(value: AppTab.profile, builder: (_) => const ProfilePage()),
          ],
        ),
      ],
    ),
  ],
);
```

### 6. Type-Safe Search, Query Adapters & Pagination with NanoPaginator

Handle URL query parameter serialization, pagination strategies, and infinite scroll lists with zero boilerplate:

#### 1. Define Typed Filter and Adapter
```dart
class UserFilter {
  final String? name;
  final String? role;
  const UserFilter({this.name, this.role});
}

class UserFilterAdapter extends NanoWriteAdapter<UserFilter> {
  const UserFilterAdapter();

  @override
  Map<String, dynamic> toMap(UserFilter query) {
    return <String, dynamic>{}
        .addIf('name', query.name)
        .addIf('role', query.role, condition: query.role != 'all');
  }
}
```

#### 2. Create Search Repository with Response Strategy
```dart
class UserSearchRepository extends NanoSearchRepository<User, String, UserFilter> {
  UserSearchRepository({
    super.endpoint = '/users',
    super.adapter = const UserAdapter(),
    super.queryAdapter = const UserFilterAdapter(),
    super.dataStrategy = const NanoDataStrategy.data(), // JSON:API 'data' envelope
    super.client,
  });
}

// Fetch all with filters & pagination (returns NanoPaginatedResult<User>):
// final result = await searchRepository.searchAll(const UserFilter(name: 'Alex'));
// print(result.items);       // List<User>
// print(result.totalCount);  // 150 (if reported by API)
// print(result.currentPage); // 1
// print(result.hasNext);     // true
```

#### 3. Response Extraction Strategies (NanoDataStrategy)
Adapt to any backend REST standard with dedicated extraction strategies:

```dart
// 1. Un-enveloped Raw Arrays (GitHub, FastAPI, Go):
const NanoDataStrategy.raw()

// 2. JSON:API / Laravel / JSend Envelope {"data": [...], "meta": {...}}:
const NanoDataStrategy.data()

// 3. Django REST Framework {"results": [...], "count": 100, "next": "..."}:
const NanoDataStrategy.results()

// 4. Google Cloud APIs {"items": [...], "totalResults": 100}:
const NanoDataStrategy.items()

// 5. Custom Envelope Key {"events": [...]}:
const NanoDataStrategy.key('events')

// 6. Custom Transformation:
NanoDataStrategy.custom(
  listExtractor: (json) => json['payload']['records'],
  metaExtractor: (json, headers) => NanoPaginationMeta(
    totalCount: json['payload']['total'],
  ),
)
```

#### 4. Automatic Infinite Scroll (Mobile) or Page Navigation Bar (Web)
```dart
// In Controller:
late final paginator = NanoPaginator<User>(
  fetcher: (pagination) => userRepository.getAll(pagination: pagination),
);

// Option A: Mobile Infinite Scroll:
NanoPaginatedListView<User>(
  paginator: controller.paginator,
  itemBuilder: (context, user, index) => ListTile(title: Text(user.name)),
);

// Option B: Web / Desktop Navigation Bar:
NanoPaginationBar(
  paginator: controller.paginator,
  showPageSizeSelector: true,
  availablePageSizes: const [5, 10, 20, 50],
);
```

#### 4. Instantaneous Caching (0ms latency & Offline fallback)
Works seamlessly across **Web, iOS, Android, macOS, Windows, and Linux**:

```dart
// 1. Configure in-memory cache globally at startup:
NanoDefaultInjections.init(
  i,
  client: DioHttpClient(Dio()),
  cache: NanoMemoryCache(defaultTtl: const Duration(minutes: 5)),
);

// 2. Fetch using cache-first (instant response on subsequent visits):
final users = await userRepository.getAll(cachePolicy: NanoCachePolicy.cacheFirst);

// 3. Force network update during pull-to-refresh:
final freshUsers = await userRepository.getAll(cachePolicy: NanoCachePolicy.networkOnly);
```

#### 5. Customizing Specific Endpoints (Overrides)

By default, `NanoRepository` constructs standard REST paths (`$endpoint`, `$endpoint/$id`, `$endpoint/${entity.id}`). You can selectively override individual operation endpoints without repeating the base URL:

```dart
class UserRepository extends NanoRepository<User, String> {
  UserRepository([super.client])
      : super(
          endpoint: '/users',
          adapter: const UserAdapter(),
        );

  // Custom update path:
  @override
  String endpointUpdate(User entity) => '$endpoint/profile';

  // Custom detail path:
  @override
  String endpointGetById(String id) => '$endpoint/details/$id';

  // Custom creation path:
  @override
  String endpointCreate(User entity) => '$endpoint/register';
}
```

#### 6. Authentication & Session Repository (NanoAuthRepository)

Standardized base repository for authentication, non-volatile token persistence via `NanoStorage`, session lifecycle, and automatic `GetIt` client/storage resolution:

```dart
class AuthRepository extends NanoAuthRepository<UserSession> {
  AuthRepository({super.client, super.storage});

  Future<bool> signInWithEmail(String email, String password) async {
    final response = await client.post<Map<String, dynamic>>(
      '/api/v4/auth/login',
      data: {'email': email, 'password': password},
    );
    if (response.isSuccess && response.data != null) {
      saveToken(response.data!['token']);
      return true;
    }
    return false;
  }

  // Optional: override refreshSession to renew access tokens using refreshToken
  @override
  Future<bool> refreshSession() async {
    if (refreshToken == null) return false;
    final response = await client.post<Map<String, dynamic>>(
      '/api/v4/auth/token',
      data: NanoOAuth.buildRefreshTokenBody(refreshToken: refreshToken!),
    );
    if (response.isSuccess && response.data != null) {
      saveToken(response.data!['token'], refreshToken: response.data!['refresh_token']);
      return true;
    }
    return false;
  }

  // Optional: override restoreSession if this repository hydrates full session objects
  @override
  Future<UserSession?> restoreSession() async {
    if (!isAuthenticated) return null;
    final response = await client.get<Map<String, dynamic>>('/api/v4/user/me');
    return response.data != null ? UserSession.fromJson(response.data!) : null;
  }
}
```

#### 7. Modern OAuth 2.0 & PKCE (NanoOAuth & NanoPkce)

Execute cryptographically secure OAuth 2.0 and OpenID Connect authorization flows (Discord, Google, Apple, GitHub, Auth0, Supabase) with built-in RFC 7636 PKCE, anti-CSRF state, and zero external dependencies:

```dart
// 1. Generate a secure PKCE challenge pair + CSRF state token:
final pkce = NanoPkce.generate(
  method: NanoPkceMethod.s256,
  includeNonce: true, // For OIDC ID Tokens (Apple, Google)
);

// 2. Build the provider's authorization URI:
final authorizationUri = NanoOAuth.buildAuthorizationUri(
  authorizationEndpoint: 'https://discord.com/api/oauth2/authorize',
  clientId: '123456789',
  redirectUri: 'myapp://oauth/callback',
  scopes: ['identify', 'email'],
  pkce: pkce,
);

// 3. Open browser/WebAuth and parse the callback redirect:
final callbackUrl = await FlutterWebAuth2.authenticate(
  url: authorizationUri.toString(),
  callbackUrlScheme: 'myapp',
);

final callback = NanoOAuthCallback.fromUrl(callbackUrl);
if (!callback.isSuccess || !callback.isValidState(pkce.state)) {
  throw Exception('OAuth verification failed or CSRF state mismatch.');
}

// 4. Exchange authorization code for access/refresh tokens:
final tokenResponse = await dio.post(
  'https://discord.com/api/oauth2/token',
  data: NanoOAuth.buildAuthorizationCodeBody(
    clientId: '123456789',
    code: callback.code!,
    redirectUri: 'myapp://oauth/callback',
    codeVerifier: pkce.codeVerifier,
  ),
  options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
);
```

#### 8. Environment & Build Modes (NanoEnvironment / NanoEnv)

Query compile-time environment flags, automatically detect development vs production releases, and read `--dart-define` variables:

```dart
// Automatic compile-time environment detection:
final isProduction = NanoEnvironment.isProduction; // true in release builds
final isDevelopment = NanoEnvironment.isDevelopment; // true in debug/development builds

// Read strongly-typed compile-time configuration:
final apiUrl = NanoEnvironment.getString('API_URL', defaultValue: 'https://api.example.com');
final customFlag = NanoEnvironment.getBool('FEATURE_ANALYTICS', defaultValue: true);
final timeoutSec = NanoEnvironment.getInt('TIMEOUT_SECONDS', defaultValue: 30);
final threshold = NanoEnvironment.getDouble('THRESHOLD', defaultValue: 1.5);

// Concise alias:
final sameFlag = NanoEnv.getBool('FEATURE_ANALYTICS');
```

#### 8. Durable Storage vs Expiring Cache (NanoStorage & NanoCache)

- **`NanoStorage`**: Ideal for permanent key-value persistence without TTL (e.g. auth tokens, user flags via `SharedPreferences` or `FlutterSecureStorage`).
- **`NanoCache`**: Ideal for volatile HTTP response caching with TTL expiration policies (e.g. `Hive` or `NanoMemoryCache`).

<details>
<summary><b>💾 Custom Storage Implementation (e.g., SharedPreferences)</b></summary>

```dart
import 'package:nano_core/nano_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage implements NanoStorage {
  final SharedPreferences prefs;
  const SharedPrefsStorage(this.prefs);

  @override
  T? get<T>(String key) => prefs.get(key) as T?;

  @override
  void set<T>(String key, T value) {
    if (value is String) prefs.setString(key, value);
    if (value is bool) prefs.setBool(key, value);
    if (value is int) prefs.setInt(key, value);
    if (value is double) prefs.setDouble(key, value);
  }

  @override
  void delete(String key) => prefs.remove(key);

  @override
  void clear({String? prefix}) {
    for (final k in prefs.getKeys()) {
      if (prefix == null || k.startsWith(prefix)) prefs.remove(k);
    }
  }

  @override
  bool has(String key) => prefs.containsKey(key);
}
```
</details>

<details>
<summary><b>⚡ Custom Persistent Cache (e.g., Hive / LocalStorage)</b></summary>

You can persist cached data across app restarts simply by implementing `NanoCache`:

```dart
import 'dart:convert';
import 'package:nano_core/nano_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsCache implements NanoCache {
  final SharedPreferences prefs;
  const SharedPrefsCache(this.prefs);

  @override
  T? get<T>(String key) {
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as T?;
  }

  @override
  void set<T>(String key, T value, {Duration? ttl}) {
    prefs.setString(key, jsonEncode(value));
  }

  @override
  void delete(String key) => prefs.remove(key);

  @override
  void clear({String? prefix}) {
    final keys = prefs.getKeys();
    for (final k in keys) {
      if (prefix == null || k.startsWith(prefix)) {
        prefs.remove(k);
      }
    }
  }

  @override
  bool has(String key) => prefs.containsKey(key);
}
```
</details>

### 6. Type-Safe Functional Results with NanoResult

Handle operations with typed business errors without throwing exceptions, using modern Dart 3 `sealed class` pattern matching:

```dart
// 1. Return typed results from UseCases or Services:
Future<NanoResult<User, String>> login(String email, String password) async {
  if (password.length < 6) {
    return const NanoResult.failure('Password too short');
  }
  try {
    final user = await authApi.authenticate(email, password);
    return NanoResult.success(user);
  } catch (e) {
    return NanoResult.failure('Invalid credentials');
  }
}

// 2. Consume with Dart 3 Pattern Matching:
final result = await login('dev@nano.core', 'secret123');

final message = switch (result) {
  NanoSuccess(:final data) => 'Welcome back, ${data.name}!',
  NanoFailure(:final error) => 'Login failed: $error',
};

// 3. Or wrap any existing async call safely:
final safeResult = await NanoResult.runAsync(() => userRepository.getAll());
```

### 7. Reactive Forms, Internationalized Validators & NanoTextField

Build robust, strongly-typed forms with immutable entities, automatic view state updates via `updateForm`, and `BuildContext` i18n support:

#### 1. Define Form Entity & View State
```dart
class UserFormEntity extends NanoFormEntity {
  const UserFormEntity({
    this.name = '',
    this.email = '',
  });

  final String name;
  final String email;

  UserFormEntity copyWith({
    String Function()? name,
    String Function()? email,
  }) =>
      UserFormEntity(
        name: name != null ? name() : this.name,
        email: email != null ? email() : this.email,
      );

  @override
  List<Object?> get props => [name, email];
}

class RegisterViewState extends NanoFormState<UserFormEntity> {
  const RegisterViewState({super.form = const UserFormEntity()});

  RegisterViewState copyWith({UserFormEntity? form}) =>
      RegisterViewState(form: form ?? this.form);
}
```

#### 2. Manage via Controller with submit & reset
```dart
class RegisterController
    extends NanoFormController<RegisterViewState, UserFormEntity> {
  final UserRepository userRepository;

  RegisterController(this.userRepository)
      : super(initialData: const RegisterViewState());

  void saveUser() {
    // 🎯 submit automatically validates all fields before execution:
    submit((form) {
      execute(() => userRepository.create(form));
    });
  }
}
```

#### 3. Render with NanoForm & Reactive NanoTextField in View
```dart
NanoForm(
  controller: controller,
  child: Column(
    children: [
      NanoTextField(
        value: state.data?.form.name,
        label: 'Full Name',
        prefixIcon: const Icon(Icons.person_outline),
        validators: [
          NanoValidator.required((context) => 'Name is required'),
          NanoValidator.minLength(3, (context) => 'Minimum 3 characters'),
        ],
        autoValidateMode: NanoAutoValidateMode.onUserInteraction,
        onChanged: (text) => controller.updateForm(
          (s) => s.copyWith(form: s.form.copyWith(name: () => text)),
        ),
      ),
      const SizedBox(height: 20),
      FilledButton(
        onPressed: controller.saveUser,
        child: const Text('Save User'),
      ),
    ],
  ),
)
```

### 8. Structured Logging with NanoLogger & NanoLogFilter

Nano Core provides an enterprise-grade structured console logger with ANSI colors, method tracing, execution timestamps, and granular category filtering via `NanoLogFilter`.

#### 🛠️ Initialization & Granular Filtering

Configure logger presets, telemetry hooks, and filters centrally in your `main()` function:

```dart
void main() {
  // Central bootstrap configuration:
  NanoLogger.init(
    // Choose a preset or custom level list:
    filter: NanoEnvironment.isDevelopment
        ? const NanoLogFilter.all()
        : const NanoLogFilter.onlyErrors(),
    showTimestamp: true,
    showColors: true,
    maxStackTraceLines: 10,
    onError: (entry) {
      // Hook errors directly into Firebase Crashlytics, Sentry, or Datadog:
      FirebaseCrashlytics.instance.recordError(
        entry.error,
        entry.stackTrace,
        reason: entry.message,
      );
    },
  );

  runApp(const MyApp());
}
```

#### 🎯 NanoLogFilter Presets

| Filter Preset | Active Levels | Typical Use Case |
| :--- | :--- | :--- |
| `NanoLogFilter.all()` | `debug`, `info`, `success`, `warning`, `error`, `http` | Local Development |
| `NanoLogFilter.onlyErrors()` | `error` | Production / Release Builds |
| `NanoLogFilter.errorsAndWarnings()` | `warning`, `error` | Staging / QA Builds |
| `NanoLogFilter.onlyHttp()` | `http` | Network & API Traffic Debugging |
| `NanoLogFilter.none()` | *None (completely silent)* | Integration & Benchmark Tests |
| `NanoLogFilter.only([...])` | Custom selection | Custom debugging workflows |

#### 🪵 Logging Events

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

// Dynamic runtime filter controls:
NanoLogger.setFilter(const NanoLogFilter.onlyHttp());
NanoLogger.disable(); // or NanoLogger.mute()
NanoLogger.enable();  // or NanoLogger.unmute()
```

> **Tip:** You can use `NanoLogger`, `NanoLog`, or `NLog` interchangeably as concise aliases.

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

// Use directly in NanoScaffold with reactive listener, toasts & fallback messages:
NanoScaffold(
  controller: blocController,
  defaultErrorMessage: 'An unexpected error occurred', // Fallback for ErrorState(key: null)
  defaultWarningMessage: 'Please review your input',   // Fallback for WarningState(key: null)
  listener: (context, state) {
    if (state is SuccessState) {
      // Execute one-time side-effects (navigation, dialogs, analytics)
    }
  },
  builder: (context, state) => Text('User: ${state.data?.name}'),
);
```

> [!NOTE]
> **Notification & Feedback Priority Order (`ErrorState` / `WarningState`):**
> 1. **Custom Hook**: If `onCustomError` or `onCustomWarning` is provided, it is invoked and bypasses automatic toasts.
> 2. **Typed Key Message**: If `key?.message(context)` produces a non-empty string, it is displayed via `NanoToast`.
> 3. **Fallback Default**: If `key` is `null` or produces an empty string, `defaultErrorMessage` or `defaultWarningMessage` is displayed if non-empty.
> 4. **Silent (No-op)**: If no message is found, no empty toast is displayed, ensuring zero visual bugs.

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

### 9. Debounced Search Inputs

Delay expensive operations or search API calls until the user pauses typing:

```dart
// Native integration with NanoTextField:
NanoTextField(
  label: 'Search products...',
  prefixIcon: const Icon(Icons.search),
  debounceDuration: const Duration(milliseconds: 400),
  onChanged: (query) => controller.search(query),
)

// Or using standalone NanoDebouncer:
final debouncer = NanoDebouncer(duration: const Duration(milliseconds: 300));
debouncer.run(() => fetchSearchResults(query));
```

---

### 10. Reactive Connectivity & Offline Handling

Monitor network connectivity state with zero external dependencies:

```dart
// 1. Register in NanoDefaultInjections:
NanoDefaultInjections.register(
  connectivity: NanoConnectivity(),
);

// 2. Observe in NanoScaffold with custom connectivityBuilder:
NanoScaffold<ProductsState, ProductsMessages>(
  controller: controller,
  connectivityBuilder: (context, status) => switch (status) {
    NanoConnectivityStatus.none => Container(
      color: Colors.red.withValues(alpha: 0.9),
      padding: const EdgeInsets.all(8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text(
            'No internet connection',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
    _ => null,
  },
  builder: (context, state) => ...,
)
```

---

### 11. Encapsulated Commands (NanoCommand & NanoCommandBuilder)

Encapsulate individual user actions and async operations into reactive commands with granular button loading indicators:

```dart
// 1. Define commands inside your controller using nanoCommand0 / nanoCommand1:
class LoginController extends NanoController<LoginViewState> {
  LoginController(this.repository);

  final AuthRepository repository;

  // Parameterless command with auto-dispose:
  late final refreshCommand = nanoCommand0<void>(
    repository.fetchProfile,
  );

  // Single-argument command with declarative success callback & auto-dispose:
  late final signInCommand = nanoCommand1<String, bool>(
    repository.signIn,
    onSuccess: (success) {
      emit(SuccessState(state.data?.copyWith(isAuthenticated: success)));
    },
    onError: (error) {
      // Custom error handling
    },
  );

  @override
  Future<void> init(String? id) async {}

  void handleSignIn(String provider) => signInCommand.run(provider);
}

// 2. Reactively bind individual buttons in UI:
NanoCommandBuilder<bool>(
  command: controller.signInCommand,
  builder: (context, cmdState) => ElevatedButton(
    onPressed: cmdState is LoadingState
        ? null
        : () => controller.signInCommand.run('google'),
    child: cmdState is LoadingState
        ? const CircularProgressIndicator()
        : const Text('Sign in with Google'),
  ),
)
```

---

### 12. Model Adapters (NanoReadAdapter, NanoWriteAdapter & NanoAdapter)

Segregated serialization and deserialization contracts following the Interface Segregation Principle, complete with built-in safe list handling (`fromList` and `toList`):

```dart
// 1. Read-Only Adapter (API responses):
class ProductAdapter extends NanoReadAdapter<Product> {
  const ProductAdapter();

  @override
  Product fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as String,
    name: json['name'] as String,
  );
}

// Safely parse nested lists from API JSON with zero manual casting:
final products = const ProductAdapter().fromList(json['products']);

// 2. Write-Only / Query Adapter (POST/PUT request payloads & URL query parameters):
class CreateOrderAdapter extends NanoWriteAdapter<OrderDraft> {
  const CreateOrderAdapter();

  static const _itemAdapter = OrderItemAdapter();

  @override
  Map<String, dynamic> toMap(OrderDraft draft) => {
    'customerId': draft.customerId,
    // Safely serialize nested list of entities to List<Map<String, dynamic>>:
    'items': _itemAdapter.toList(draft.items),
  };
}

// 3. Bidirectional Adapter (Full CRUD entities):
class UserAdapter extends NanoAdapter<User> {
  const UserAdapter();

  @override
  User fromMap(Map<String, dynamic> map) => User(
    id: map['id'] as String,
    name: map['name'] as String,
  );

  @override
  Map<String, dynamic> toMap(User user) => {
    'id': user.id,
    'name': user.name,
  };
}
```

---

### 13. Dependency Injection (NanoInjections, Async Binds & NanoDefaultInjections)

Manage scoped dependency lifecycles with `GetIt` supporting both synchronous and asynchronous bindings without manual scope management:

```dart
// 1. Root Application Injections (Supports async bindings with `Future<void> binds`):
class AppInjections extends NanoInjections {
  const AppInjections({super.scope = 'app_global'});

  @override
  Future<void> binds(GetIt i) async {
    final prefs = await SharedPreferences.getInstance();
    final cache = await AppHiveCache.init();
    final storage = AppSharedPreferencesStorage(prefs);

    final config = AppEnvironments.current;
    i.registerSingleton<AppConfig>(config);

    final client = AppDioHttpClient(
      baseUrl: config.apiBaseUrl,
      interceptors: [
        const NanoAuthInterceptor(),
        if (config.logEnabled) const NanoHttpLogInterceptor(),
      ],
    );

    // Initialize default framework services:
    NanoDefaultInjections.init(
      i,
      client: client,
      storage: storage,
      cache: cache,
    );
  }
}

// 2. Minimalist Main Bootstrap:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await const AppInjections()();
  runApp(const App());
}

// 3. Feature/Module Injections (Synchronous bindings):
class LoginInjections extends NanoInjections {
  const LoginInjections({super.scope = 'login'});

  @override
  void binds(GetIt i) {
    i
      ..registerLazySingleton<AuthRepository>(() => AuthRepository())
      ..registerFactory<LoginController>(
        () => LoginController(i<AuthRepository>()),
      );
  }
}
```

---

## 💖 Supporting & Sponsoring

`nano_core` is an open-source framework created to elevate architecture, performance, and developer experience in Flutter multiplatform applications. If this framework saved you time or is helping your team, consider supporting its continuous development:

- ⭐ **Star the Project**: Give us a star on [GitHub](https://github.com/durvalperipato/nano-core) to help more developers discover the project!
- ☕ **Buy Me a Coffee**: Support development via [Buy Me a Coffee](https://buymeacoffee.com/nanodevs)
- 🔑 **PIX (Brazil)**: `durvalperipatoneto@gmail.com`

---

## 💬 Community, Support & Feedback

- 🐛 **Issue Tracker**: [GitHub Issues](https://github.com/durvalperipato/nano-core/issues)
- 💡 **Discussions**: [GitHub Discussions](https://github.com/durvalperipato/nano-core/discussions)
- ✉️ **Direct Contact**: [durvalana8893@gmail.com](mailto:durvalana8893@gmail.com)
- 🌐 **Website**: [nanodevs.com.br](https://nanodevs.com.br)
- 💼 **Author**: [Durval Peripato Neto](https://github.com/durvalperipato)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
