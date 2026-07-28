# Nano Core

A lightweight reactive architecture framework and design system toolkit for Flutter multiplatform applications.

## Features

- 🚀 **NanoScaffold**: Reactive base page scaffold supporting Web/Desktop headers, mobile AppBars, loading overlays, and error notifications.
- ⚡ **NanoController & NanoState**: Clean, reactive state management built on `ChangeNotifier` and `ListenableBuilder`.
- 🛠️ **NanoCommand**: Encapsulated async commands for user actions and operations.
- 🧩 **Design System Components**: Standalone reusable UI widgets such as `NanoLoadingOverlay`.
- 💉 **NanoInjections**: Dependency injection scoping with `GetIt`.

## Getting Started

Add `nano_core` to your `pubspec.yaml`:

```yaml
dependencies:
  nano_core: ^0.0.3
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
