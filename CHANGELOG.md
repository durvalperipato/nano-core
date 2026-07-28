## 0.0.3-beta.1 - 2026-07-28

- Added complete explicit Dartdoc constructor documentation across `NanoController`, `NanoLoadingOverlay`, `NanoScaffold`, `NanoStatePage`, and `NanoToast` to pass pub.dev Pana analysis checks.
- Re-architected showcase `example` app into clean modular feature layers following `nano-budgets` design (`app/core/theme`, `app/pages/showcase/widgets`).
- Removed unused `lib/main.dart` entrypoint from package core.
- Updated package metadata and `README.md` with active Beta status notice and badges.

## 0.0.2 - 2026-07-24

- Added `NanoToast` smart multiplatform notification component for Web, Desktop, and Mobile.
- Added `NanoDeviceType` for robust platform and responsive screen environment detection.
- Added `warning` state status and helpers (`isWarning`, `toWarning()`) in `NanoState`.
- Added `onCustomError`, `onCustomWarning`, and `onCustomSuccess` callbacks to `NanoScaffold`.
- Added `homepage` URL (`https://nanodevs.com.br`) in package metadata.
- Comprehensive English Dartdoc documentation for all core APIs.

## 0.0.1 - 2026-07-24

- Initial release of `nano_core`.
- Added reactive state management (`NanoState`, `NanoController`, `NanoCommand`).
- Added multiplatform layout scaffold (`NanoScaffold`).
- Added reusable design system components (`NanoLoadingOverlay`).
- Added dependency injection bindings (`NanoInjections`).
