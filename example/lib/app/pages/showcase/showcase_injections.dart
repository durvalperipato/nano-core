import 'package:get_it/get_it.dart';
import 'package:nano_core/nano_core.dart';
import 'showcase_controller.dart';

/// Dependency injection bindings for the showcase page scope.
class ShowcaseInjections extends NanoInjections {
  /// Creates a new [ShowcaseInjections] scope.
  ShowcaseInjections() : super(scope: 'showcase');

  @override
  void binds(GetIt i) {
    i.registerFactory<ShowcaseController>(() => ShowcaseController());
  }
}
