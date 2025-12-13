import 'package:flutter/material.dart';
import 'package:nano_core/controller/nano_controller.dart';

class NanoScaffold extends StatefulWidget {
  const NanoScaffold({
    super.key,
    required this.controller,
    required this.builder,
  });

  final NanoController controller;
  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  State<NanoScaffold> createState() => _NanoScaffoldState();
}

class _NanoScaffoldState extends State<NanoScaffold> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListenableBuilder(
          listenable: widget.controller,
          builder: widget.builder,
        ),
      ),
    );
  }
}
