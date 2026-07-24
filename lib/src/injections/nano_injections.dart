import 'package:get_it/get_it.dart';

abstract class NanoInjections {
  const NanoInjections({required this.scope});

  final String scope;

  void binds(GetIt i);
}
