import 'package:get_it/get_it.dart';

abstract class NanoInjections {
  const NanoInjections({required this.scope});

  final String scope;

  void binds(GetIt i);

  void initScope() {
    if (!GetIt.I.hasScope(scope)) {
      GetIt.I.pushNewScope(scopeName: scope, init: (i) => binds(i));
    }
  }

  void dropScope() {
    if (GetIt.I.hasScope(scope)) GetIt.I.dropScope(scope);
  }
}
