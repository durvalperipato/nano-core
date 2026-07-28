# Changelog

All notable changes to the `nano_core` project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## 0.0.4-beta.1 - 2026-07-28

### Added
- Added strict linting rules in `analysis_options.yaml` (`sort_constructors_first`, `sort_unnamed_constructors_first`, `lines_longer_than_80_chars`, `always_declare_return_types`, `prefer_single_quotes`, and `unawaited_futures`).

### Changed
- Reordered constructors across core classes to satisfy `sort_constructors_first`.
- Excluded `example/**` directory from strict documentation linting while preserving 100% strict Dartdoc enforcement on core `lib/` package APIs.

## 0.0.3-beta.1 - 2026-07-28

### Added
- Added complete explicit Dartdoc constructor documentation across `NanoController`, `NanoLoadingOverlay`, `NanoScaffold`, `NanoStatePage`, and `NanoToast` to pass pub.dev Pana analysis checks.
- Re-architected showcase `example` app into clean modular feature layers following `nano-budgets` design (`app/core/theme`, `app/pages/showcase/widgets`).
- Updated package metadata and `README.md` with active Beta status notice and badges.

### Removed
- Removed unused `lib/main.dart` entrypoint from package core.

## 0.0.2 - 2026-07-24

### Added
- Added `NanoToast` smart multiplatform notification component for Web, Desktop, and Mobile.
- Added `NanoDeviceType` for robust platform and responsive screen environment detection.
- Added `warning` state status and helpers (`isWarning`, `toWarning()`) in `NanoState`.
- Added `onCustomError`, `onCustomWarning`, and `onCustomSuccess` callbacks to `NanoScaffold`.
- Added `homepage` URL (`https://nanodevs.com.br`) in package metadata.
- Comprehensive English Dartdoc documentation for all core APIs.

## 0.0.1 - 2026-07-24

### Added
- Initial release of `nano_core`.
- Added reactive state management (`NanoState`, `NanoController`, `NanoCommand`).
- Added multiplatform layout scaffold (`NanoScaffold`).
- Added reusable design system components (`NanoLoadingOverlay`).
- Added dependency injection bindings (`NanoInjections`).
