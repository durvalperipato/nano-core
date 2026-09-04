import 'internal/nano_shell_controller_base.dart';

/// A strongly typed reactive controller for managing tabs and contextual
/// sub-views in a [NanoShellScaffold].
class NanoShellController<TTab extends Enum, TSubView>
    extends NanoShellControllerBase {
  /// Creates a [NanoShellController] instance.
  NanoShellController({
    TTab? initialTab,
    TSubView? initialSubView,
  })  : _currentTab = initialTab,
        _activeSubView = initialSubView;

  TTab? _currentTab;
  TSubView? _activeSubView;

  /// The currently selected primary tab.
  TTab? get currentTab => _currentTab;

  /// The currently active sub-view, or `null` if a primary tab is shown.
  TSubView? get activeSubView => _activeSubView;

  @override
  bool get isShowingSubView => _activeSubView != null;

  /// The effective active tab (returns `null` when a sub-view is active).
  TTab? get effectiveActiveTab => isShowingSubView ? null : _currentTab;

  /// Switches the active primary tab and closes any open sub-view.
  void selectTab(TTab tab) {
    if (_currentTab == tab && _activeSubView == null) return;
    _currentTab = tab;
    _activeSubView = null;
    notifyListeners();
  }

  /// Opens a contextual sub-view while preserving the underlying tab state.
  void openSubView(TSubView subView) {
    if (_activeSubView == subView) return;
    _activeSubView = subView;
    notifyListeners();
  }

  @override
  void closeSubView() {
    if (_activeSubView == null) return;
    _activeSubView = null;
    notifyListeners();
  }

  /// Sets or clears the active sub-view.
  void setSubView(TSubView? subView) {
    if (_activeSubView == subView) return;
    _activeSubView = subView;
    notifyListeners();
  }
}
