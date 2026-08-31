import 'package:flutter/material.dart';
import '../router/nano_router.dart';

/// The root application widget for apps using the nano-core framework.
///
/// Wraps [MaterialApp] and automatically configures [NanoRouter] navigation,
/// including [navigatorKey], [initialRoute], and [onGenerateRoute].
class NanoApp extends StatelessWidget {
  /// Creates a [NanoApp] instance.
  const NanoApp({
    this.router,
    this.home,
    this.title = '',
    this.onGenerateTitle,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.builder,
    this.navigatorObservers = const <NavigatorObserver>[],
    super.key,
  });

  /// The declarative [NanoRouter] instance managing navigation.
  final NanoRouter? router;

  /// The default widget for the default route of the app (when not using
  /// [router]).
  final Widget? home;

  /// A one-line description used for the device app switcher.
  final String title;

  /// If non-null, this callback is used to generate the title.
  final String Function(BuildContext)? onGenerateTitle;

  /// Default visual theme for the app.
  final ThemeData? theme;

  /// Visual theme for dark mode.
  final ThemeData? darkTheme;

  /// Visual theme for high contrast mode.
  final ThemeData? highContrastTheme;

  /// Visual theme for high contrast dark mode.
  final ThemeData? highContrastDarkTheme;

  /// Which theme to use (light, dark, or system).
  final ThemeMode? themeMode;

  /// Primary color to use for the application switcher.
  final Color? color;

  /// The initial locale for this app's widgets.
  final Locale? locale;

  /// The delegates for this app's [Localizations] widget.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Callback to resolve locale when multiple are available.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Callback to resolve single locale.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// The list of locales that this app has been localized for.
  final Iterable<Locale> supportedLocales;

  /// Turns on a grid overlay for debugging material layout.
  final bool debugShowMaterialGrid;

  /// Turns on a performance overlay.
  final bool showPerformanceOverlay;

  /// Checkerboard offscreen layers.
  final bool checkerboardOffscreenLayers;

  /// Turns on an overlay showing semantics info.
  final bool showSemanticsDebugger;

  /// Shows the "DEBUG" banner in debug mode.
  final bool debugShowCheckedModeBanner;

  /// Keyboard shortcuts for the application.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Actions for the application.
  final Map<Type, Action<Intent>>? actions;

  /// State restoration scope ID.
  final String? restorationScopeId;

  /// Scroll behavior for the application.
  final ScrollBehavior? scrollBehavior;

  /// Builder for wrapping the root navigator or home widget.
  final TransitionBuilder? builder;

  /// Observers for the navigator.
  final List<NavigatorObserver> navigatorObservers;

  @override
  Widget build(BuildContext context) {
    final effectiveRouter = router;

    if (effectiveRouter != null) {
      return MaterialApp(
        key: key,
        navigatorKey: NanoRouter.navigatorKey,
        initialRoute: effectiveRouter.initialRoute,
        onGenerateRoute: effectiveRouter.onGenerateRoute,
        title: title,
        onGenerateTitle: onGenerateTitle,
        theme: theme,
        darkTheme: darkTheme,
        highContrastTheme: highContrastTheme,
        highContrastDarkTheme: highContrastDarkTheme,
        themeMode: themeMode,
        color: color,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
        scrollBehavior: scrollBehavior,
        builder: builder,
        navigatorObservers: [
          ...effectiveRouter.observers,
          ...navigatorObservers,
        ],
      );
    }

    return MaterialApp(
      key: key,
      home: home,
      title: title,
      onGenerateTitle: onGenerateTitle,
      theme: theme,
      darkTheme: darkTheme,
      highContrastTheme: highContrastTheme,
      highContrastDarkTheme: highContrastDarkTheme,
      themeMode: themeMode,
      color: color,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      debugShowMaterialGrid: debugShowMaterialGrid,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
      scrollBehavior: scrollBehavior,
      builder: builder,
      navigatorObservers: navigatorObservers,
    );
  }
}
