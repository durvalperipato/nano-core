import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nano Core Example',
      theme: ThemeData.dark(),
      home: SamplePage(controller: SampleController()),
    );
  }
}

class SampleController extends NanoController<String> {
  Future<void> loadData() async {
    execute(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Hello from Nano Core!';
    });
  }
}

class SamplePage extends StatelessWidget {
  const SamplePage({super.key, required this.controller});

  final SampleController controller;

  @override
  Widget build(BuildContext context) {
    return NanoScaffold(
      controller: controller,
      header: AppBar(
        title: const Text('Nano Core Example'),
      ),
      builder: (context, child) {
        final data = controller.state.data;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data ?? 'Press button to load data',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.loadData,
                child: const Text('Load Data'),
              ),
            ],
          ),
        );
      },
    );
  }
}
