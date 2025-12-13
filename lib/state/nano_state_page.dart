import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nano_core/controller/nano_controller.dart';
import 'package:nano_core/injections/nano_injections.dart';

abstract class NanoStatePage<U extends StatefulWidget, T extends NanoController>
    extends State<U> {
  NanoInjections get injections;

  String? get id => null;

  late final T controller;

  @override
  void initState() {
    injections.binds(GetIt.instance);
    controller = GetIt.I.get<T>();
    controller.init(id);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
