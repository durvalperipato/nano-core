# Changelog

All notable changes to the `nano_core` project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

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
