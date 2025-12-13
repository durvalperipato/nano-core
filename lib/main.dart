import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nano_core/controller/nano_controller.dart';
import 'package:nano_core/injections/nano_injections.dart';
import 'package:nano_core/scaffold/nano_scaffold.dart';
import 'package:nano_core/state/nano_state_page.dart';

void main() {
  runApp(const NanoApp());
}

class NanoApp extends StatelessWidget {
  const NanoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends NanoStatePage<HomePage, HomeController> {
  @override
  Widget build(BuildContext context) {
    return NanoScaffold(
      controller: controller,
      builder: (_, _) {
        return Placeholder();
      },
    );
  }

  @override
  NanoInjections get injections => HomeInjections();
}

class HomeController extends NanoController {
  @override
  Future<void> init(String? id) async {}
}

class HomeInjections extends NanoInjections {
  const HomeInjections({super.scope = 'home'});

  @override
  void binds(GetIt i) {
    i.registerLazySingleton<HomeController>(() => HomeController());
  }
}
