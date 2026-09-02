# Changelog

All notable changes to the `nano_core` project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.6.0

### Breaking Changes
- `NanoAuthRepository`: Uses `NanoStorage` instead of `NanoCache` for non-volatile token persistence.
- `NanoController`: `init(String? id)` is now an abstract method requiring explicit implementation across all controllers extending `NanoController`.
- `NanoCommand`: `NanoCommand0.run()` is now parameterless and `NanoCommand1.run(arg)` accepts only the action argument; callbacks (`onSuccess`, `onError`) and `emitLoadingOnRequest` are now configured declaratively at creation time.
- `NanoCommand`: Renamed `execute(...)` to `run(...)` for triggering encapsulated actions with automatic `toLoaded` transition.
- `NanoState`: Added `LoadedState<T>` to the sealed class hierarchy (requires handling `LoadedState` in exhaustive pattern matching switch expressions).

### Added
- `NanoStorage`: Standardized contract for durable key-value persistence without TTL expiration.
- `LoadedState<T>` and `toLoaded(data)` to `NanoState` hierarchy for regular data-ready states without triggering feedback toasts.
- `onSuccess` and `onError` optional callbacks to `NanoController.execute`.
- `emitLoadingOnRequest` parameter (defaults to `true`) to `NanoController.execute` for customizable loading emissions.
- Generic `execute<T>` in `NanoController` returning typed results directly into `onSuccess(T result)`.
- `NanoController`: Added `nanoCommand0` and `nanoCommand1` factory methods for creating encapsulated commands with declarative callbacks and automatic lifecycle disposal.
- Granular customizable endpoint methods in `NanoRepository` (`endpointGetAll`, `endpointGetById`, `endpointCreate`, `endpointUpdate`, `endpointDelete`, `fetchList`) and `NanoSearchRepository` (`endpointSearch`).
- `NanoAuthRepository<Session>`: Standardized base authentication repository for session restoration, token persistence (`saveToken`, `clearSession`, `isAuthenticated`), and lifecycle management.
- `NanoAuthInterceptor`: Out-of-the-box HTTP interceptor for automatic Bearer token injection using `NanoAuthRepository` as the single source of truth, path exclusion, and automatic 401 handling.
- `NanoInjections`: Added callable `call()` invocation allowing `await const AppInjections()()` and automatic `GetIt.allReady()` resolution without manual boilerplate.
- `NanoDefaultInjections`: Added `storage` and `authRepository` parameters to `init`, `register`, and `binds` for automatic container registration.
- `NanoEnvironment`: Utility with compile-time environment flags (`isProduction`, `isDevelopment`, `isProfile`), `--dart-define` variable getters, and automatic execution mode detection.
- `NanoHttpClient`: Added constructor `interceptors` parameter for declarative pipeline registration at initialization.

### Changed
- `NanoScaffold`: Success state transitions no longer automatically display default text toasts from `ViewState` models.

## 0.5.0 (2026-09-01)

### Added
- `NanoDebouncer`: Flexible async execution delay for search inputs, autocomplete, and live filters with native `NanoTextField(debounceDuration: ...)` integration.
- `NanoConnectivity` & `NanoConnectivityStatus`: Zero-dependency cross-platform reactive network monitor supporting Wi-Fi, Cellular (4G/5G), Ethernet, Bluetooth, VPN, and Offline states.
- `connectivity` registration support in `NanoDefaultInjections.init` and `NanoDefaultInjections.register`.

### Changed
- **Clean Code Generics Refactor**: Standardized descriptive and semantic generic type parameters across all classes and adapters (`ViewState`, `MessageKey`, `Entity`, `Id`, `Query`, `Success`, `Failure`, `FormEntity`, `Args`, `Output`, `PageWidget`).
- Simplified `NanoScaffold` layout slots into unified builders (`header`, `drawer`, `footer`, `floatingActionButton`, `builder`).
- Integrated `NanoConnectivity` observation and custom `connectivityBuilder` directly into `NanoScaffold`.
- Enforced strict arrow function syntax (`=>`) for all single-line methods across the framework.

## 0.5.0 (2026-09-01)

- **Clean Code Generics Refactor**: Standardized descriptive and semantic generic type parameters across all classes and adapters (`ViewState`, `MessageKey`, `Entity`, `Id`, `Query`, `Success`, `Failure`, `FormEntity`, `Args`, `Output`, `PageWidget`).
- `NanoDebouncer`: Flexible async execution delay for search inputs, autocomplete, and live filters with native `NanoTextField(debounceDuration: ...)` integration.
- `NanoConnectivity` & `NanoConnectivityStatus`: Zero-dependency cross-platform reactive network monitor supporting Wi-Fi, Cellular (4G/5G), Ethernet, Bluetooth, VPN, and Offline states.
- Simplified `NanoScaffold` layout slots into unified builders (`header`, `drawer`, `footer`, `floatingActionButton`, `builder`).
- Integrated `NanoConnectivity` observation and custom `connectivityBuilder` directly into `NanoScaffold`.
- Added `connectivity` registration support to `NanoDefaultInjections.init` and `NanoDefaultInjections.register`.
- Enforced strict arrow function syntax (`=>`) for all single-line methods across the framework.

---

## 0.4.0 (2026-08-31)

### Added
- `NanoDefaultInjections`: Central default dependency injection container with `NanoDefaultInjections.init(i, client: ..., pagination: ..., cache: ...)` and `register()` helpers for framework-level services.
- `NanoCache`, `NanoCachePolicy` & `NanoMemoryCache`: Built-in zero-dependency caching layer with configurable policies (`cacheFirst`, `networkFirst`, `networkOnly`, `cacheOnly`), TTL expiration, and automatic cache invalidation on mutations.
- `NanoResult`, `NanoSuccess` & `NanoFailure`: Functional result pattern using Dart 3 sealed class hierarchy with compile-time pattern matching, `fold`, `map`, `mapError`, and `runAsync` safe execution helpers.
- `NanoFormEntity`, `NanoFormState` & `NanoFormController`: Strongly-typed immutable form state management system with `copyWith`, `updateForm` lifecycle, and reactive state emissions.
- `NanoValidator`: Rich collection of chainable form validators (`required`, `email`, `minLength`, `maxLength`, `min`, `max`, `pattern`, `match`, `cpf`, `cnpj`, `custom`) with dynamic `BuildContext` internationalization (i18n) support.
- `NanoAutoValidateMode`: Granular validation trigger modes (`onSubmit`, `onUserInteraction`, `onFocusLost`, `always`, `disabled`).
- `NanoTextField`: Reactive text field UI component with automatic controller/focus synchronization, password visibility toggle, and localized error rendering.
- `NanoPagination`, `NanoOffsetPagination` & `NanoCursorPagination`: Universal pluggable pagination contracts for Offset/Page-based and Cursor/Token-based strategies.
- `NanoPaginator`: Stateful pagination controller managing page progression, accumulated items, and async page lifecycle.
- `NanoPaginatedListView`: Reactive component widget for automatic infinite scrolling, pull-to-refresh, bottom spinner loading, and empty/error state handling.
- `NanoPaginationBar`: Reactive component navigation bar with next/previous page triggers, page indicators, and dynamic `pageSize` selector.
- `NanoQueryAdapter`: Dedicated abstract contract for serializing strongly-typed query and filter models into URL query parameters without forcing unused JSON deserialization.
- `NanoSearchRepository`: Specialized generic repository requiring a `NanoQueryAdapter` to perform type-safe query searches via `search(Q query)`.

### Changed
- Integrated `pagination` parameter into `NanoRepository.getAll` and `NanoSearchRepository.search`.
- Made `client` parameter optional in `NanoRepository` and `NanoSearchRepository` with automatic fallback to `GetIt.I<NanoHttpClient>()`.

## 0.3.0 (2026-08-31)

### Added
- `NanoRouteObserver`: Dedicated navigation observer with granular callbacks (`onRouteChange`, `onRoutePushed`, `onRoutePopped`, `onRouteReplaced`, `onRouteRemoved`) for screen analytics, telemetry, and logging.
- `observers` property on `NanoRouter` and automated observer forwarding in `NanoApp`.
- `NanoHttpInterceptor`: Extensible contract for intercepting and mutating HTTP requests, responses, and handling errors (JWT injection, refresh tokens, retries).
- `NanoHttpRequest` and `NanoHttpError`: Standardized immutable and equatable models for HTTP requests and structured network errors.
- `NanoHttpLogInterceptor`: Ready-to-use HTTP traffic logger for requests, responses, headers, bodies, and exceptions in developer tools.
- `NanoLogger`: Central structured logger with severity levels (`debug`, `info`, `success`, `warning`, `error`, `http`), ANSI terminal styling, method tracking, data payloads, and global telemetry hooks (`onError`, `customPrinter`).
- `NanoStateObservable`: Universal abstract state contract allowing `NanoScaffold` to observe any state management approach (BLoC, Cubit, MobX, Signals, or custom `ChangeNotifier` adapters).
- `NanoStreamAdapter`: Generic adapter bridging any `Stream` (BLoC, Cubit, RxDart, WebSockets) into `NanoStateObservable`.
- `NanoListenableAdapter`: Generic adapter bridging any `Listenable` (MobX, Signals, ValueNotifier, ChangeNotifier) into `NanoStateObservable`.

### Changed
- Decoupled `NanoScaffold`'s `controller` parameter to accept any `NanoStateObservable<T>`.
- Implemented `NanoStateObservable<T>` on `NanoController<T>`.

## 0.2.0 (2026-08-30)

### Added
- `NanoApp`: Root application widget that automatically configures `NanoRouter`, `MaterialApp`, themes, and localizations.
- Declarative routing architecture with `NanoRouter`, `NanoRoute`, `NanoAnimatedRoute`, `NanoDetailsRoute`, `NanoGroupRoute`, `NanoProtectedRoute`, `NanoRedirectRoute`, `NanoPaths`, `NanoRouteArgs`, `NanoRouteCode`, and `NanoRouteError`.
- `NanoAnimatedRoute`: Predefined animated route transitions (`fade`, `slideUp`, `slideRight`, `scale`) and custom `transitionBuilder` support.
- `NanoProtectedRoute`: Route guard wrapper with inheritance support protecting nested routes and redirecting unauthorized users.
- `NanoDetailsRoute<T>`: Specialized typed detail routes with automated generic argument extraction.
- `NanoGroupRoute`: Path-only route grouping without standalone page rendering.
- `NanoGuardedPage` & `NanoErrorPage`: Dedicated widget classes for route guard evaluation and custom 404/error pages.
- Navigation extensions on `BuildContext` (`toNamed`, `toReplacementNamed`, `toAndRemoveUntilNamed`, `back`, `routeArgs`).
- `NanoScaffoldBuilder` & `NanoScaffoldHeader`: Dedicated presentation widget components replacing inline builder helper functions.
- `loadingWidget` property on `NanoScaffold` and `child` on `NanoLoadingOverlay` for fully customizable loading states.
- Modular `NanoInjections` composition support and pattern demonstration in example.

## 0.1.0 (2026-08-29)

### Breaking Changes
- **`NanoController<T>`**: Now strictly enforces `T extends NanoViewState`. Primitive types (`String`, `int`, etc.) or arbitrary unbounded types are no longer permitted as state data models.
- **`NanoScaffold<T, M>`**: Builder signature updated from `Widget Function(BuildContext, Widget?)` to `Widget Function(BuildContext, NanoState<T>)` allowing direct reactive state access. Added support for typed message keys `M extends NanoMessageKey` and dynamic builders (`headerBuilder`, `footerBuilder`, `drawerBuilder`, `floatingActionButtonBuilder`).
- **`NanoStatePage<W, C>`**: Generic parameter for `NanoInjections` removed. `injections` is now an abstract getter `NanoInjections get injections;` with automatic GetIt scope initialization (`initScope`) and teardown (`dropScope`).

### Added
- `NanoHttpClient` interface defining standardized HTTP client contracts.
- `NanoHttpResponse` generic response model with `NanoHttpResponseExtension` helpers (`isSuccess`, `isClientError`, `isServerError`).
- `NanoHttpCode` status code constants.
- `NanoAdapter` abstract generic model adapter for JSON serialization and deserialization.
- `NanoEntity` base generic entity with unique identifier and value equality.
- `NanoRepository` base generic CRUD repository with automated serialization.
- `NanoViewState` base class enforcing structured, equatable view state models for `NanoController`.

### Removed
- `NanoStateContent` in favor of the standardized `NanoViewState`.

## 0.0.5 (2026-08-27)

### Added
- GitHub repository link to header of `example/lib/main.dart`.
- Full internationalization (l10n) support in `example` with `flutter_localizations` and `intl`.

### Changed
- `NanoMessageKey` refactored to use `String Function(BuildContext) get message` instead of `String get message` to allow highly decoupled, on-demand localization via Context.
- `NanoState` now defines `key` as a nullable `NanoMessageKey?`, removing the need for mandatory wrappers.
- `NanoScaffold` and `StateSimulatorCard` updated to call `message(context)` and elegantly fallback when no key is provided.

## 0.0.4 (2026-07-28)

### Added
- Strict linting rules in `analysis_options.yaml` (`sort_constructors_first`, `sort_unnamed_constructors_first`, `lines_longer_than_80_chars`, `always_declare_return_types`, `prefer_single_quotes`, and `unawaited_futures`).

### Changed
- Constructors reordered across core classes to satisfy `sort_constructors_first`.
- `example/**` directory excluded from strict documentation linting while preserving 100% strict Dartdoc enforcement on core `lib/` package APIs.

## 0.0.3 (2026-07-28)

### Added
- Complete explicit Dartdoc constructor documentation across `NanoController`, `NanoLoadingOverlay`, `NanoScaffold`, `NanoStatePage`, and `NanoToast` to pass pub.dev Pana analysis checks.
- Showcase `example` app re-architected into clean modular feature layers following `nano-budgets` design (`app/core/theme`, `app/pages/showcase/widgets`).
- Package metadata and `README.md` updated with active Beta status notice and badges.

### Removed
- Unused `lib/main.dart` entrypoint from package core.

## 0.0.2 (2026-07-24)

### Added
- `NanoToast` smart multiplatform notification component for Web, Desktop, and Mobile.
- `NanoDeviceType` for robust platform and responsive screen environment detection.
- `warning` state status and helpers (`isWarning`, `toWarning()`) in `NanoState`.
- `onCustomError`, `onCustomWarning`, and `onCustomSuccess` callbacks to `NanoScaffold`.
- `homepage` URL (`https://nanodevs.com.br`) in package metadata.
- Comprehensive English Dartdoc documentation for all core APIs.

## 0.0.1 (2026-07-24)

### Added
- Initial release of `nano_core`.
- Reactive state management (`NanoState`, `NanoController`, `NanoCommand`).
- Multiplatform layout scaffold (`NanoScaffold`).
- Reusable design system components (`NanoLoadingOverlay`).
- Dependency injection bindings (`NanoInjections`).
