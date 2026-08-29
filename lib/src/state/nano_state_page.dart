import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/nano_controller.dart';
import '../injections/nano_injections.dart';

/// A base state class for [StatefulWidget] views integrating
/// [NanoController] and [NanoInjections].
///
/// Generic type parameters:
/// - [U]: Target [StatefulWidget].
/// - [T]: Associated [NanoController].
abstract class NanoStatePage<U extends StatefulWidget, T extends NanoController>
    extends State<U> {
  /// Creates a new [NanoStatePage] instance.
  NanoStatePage();

  /// Dependency injection container instance for this page scope.
  NanoInjections get injections;

  /// Optional page or resource identifier.
  String? get id => null;

  /// Controller instance managing page state.
  late final T controller;

  @override
  void initState() {
    super.initState();
    injections.initScope();
    controller = GetIt.I.get<T>();
    controller.init(id);
  }

  @override
  void dispose() {
    controller.dispose();
    injections.dropScope();
    super.dispose();
  }
}

