import 'package:flutter/foundation.dart';

/// Base contract for reactive shell navigation controllers.
abstract class NanoShellControllerBase extends ChangeNotifier {
  /// Whether a contextual sub-view is currently active.
  bool get isShowingSubView;

  /// Closes the currently active sub-view and reveals the underlying tab.
  void closeSubView();
}
