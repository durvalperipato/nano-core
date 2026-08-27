# Nano Core

[![Pub Version](https://img.shields.io/pub/v/nano_core)](https://pub.dev/packages/nano_core)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Stable](https://img.shields.io/badge/Status-Stable-green.svg)](#)

A lightweight reactive architecture framework and design system toolkit for Flutter multiplatform applications.

## Features

- 🚀 **NanoScaffold**: Reactive base page scaffold supporting Web/Desktop headers, mobile AppBars, loading overlays, and error/warning/success toasts.
- ⚡ **NanoController & NanoState**: Clean, reactive state management built on `ChangeNotifier` and `ListenableBuilder`.
- 🛠️ **NanoCommand & NanoCommandBuilder**: Encapsulated async commands for user actions and operations.
- 🧩 **Design System Components**: Standalone reusable UI widgets such as `NanoLoadingOverlay` and `NanoToast`.
- 💉 **NanoInjections & NanoStatePage**: Dependency injection scoping with `GetIt` and page lifecycle binding.
- 🖥️ **NanoDeviceType**: Real-time cross-platform environment and responsive viewport width inspection.

## Getting Started

Add `nano_core` to your `pubspec.yaml`:

```yaml
dependencies:
  nano_core: ^0.0.5
```

## Quick Example

```dart
import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';

class MyController extends NanoController<String> {
  Future<void> loadData() async {
    execute(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Data loaded successfully!';
    });
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key, required this.controller});

  final MyController controller;

  @override
  Widget build(BuildContext context) {
    return NanoScaffold(
      controller: controller,
      header: AppBar(title: const Text('Nano Core Example')),
      builder: (context, child) {
        return Center(
          child: Text(controller.state.data ?? 'No data'),
        );
      },
    );
  }
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
