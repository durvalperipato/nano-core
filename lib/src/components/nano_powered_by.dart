import 'package:flutter/material.dart';

import '../utils/nano_app_info.dart';

/// A lightweight, customizable branding widget to display developer
/// or organization attribution in drawers, footers, or settings pages.
///
/// If [version] is omitted, it automatically resolves the application version
/// natively from Android/iOS, or via asset fallback if configured.
///
/// ### Example 1: Native Platform (Android & iOS) - Zero Configuration
/// [NanoPoweredBy] queries the host operating system directly via
/// `PackageManager` (Android) or `Bundle.main` (iOS). No asset declarations
/// or third-party packages are required:
/// ```dart
/// NanoPoweredBy(
///   companyName: 'NanoDevs',
///   prefix: 'Powered by',
///   logo: Image.asset('assets/images/logo.png', width: 28, height: 28),
///   onTap: () => showAboutDialog(context: context),
/// )
/// ```
///
/// ### Example 2: Declaring `pubspec.yaml` in `assets:` (Web/Desktop/Fallback)
/// For platforms without native channels or to load directly from the file,
/// add `pubspec.yaml` to your app's assets:
/// ```yaml
/// # pubspec.yaml of your application:
/// flutter:
///   assets:
///     - pubspec.yaml
/// ```
/// Then use the widget normally (the fallback will parse the asset):
/// ```dart
/// NanoPoweredBy(
///   companyName: 'NanoDevs',
///   prefix: 'Powered by',
///   logo: Image.asset('assets/images/logo.png', width: 28, height: 28),
/// )
/// ```
///
/// ### Example 3: Explicit Version (Manual Override)
/// Pass the [version] parameter directly to pin or customize the display:
/// ```dart
/// NanoPoweredBy(
///   companyName: 'NanoDevs',
///   prefix: 'Powered by',
///   version: 'v2.1.0',
///   isCompact: true,
///   companyTextStyle: const TextStyle(
///     fontWeight: FontWeight.bold,
///     color: Colors.blueAccent,
///   ),
///   onTap: () => launchUrl(Uri.parse('https://nanodevs.com.br')),
/// )
/// ```
class NanoPoweredBy extends StatefulWidget {
  /// Creates a [NanoPoweredBy] widget.
  const NanoPoweredBy({
    required this.companyName,
    this.prefix,
    this.version,
    this.logo,
    this.onTap,
    this.isCompact = false,
    this.companyTextStyle,
    this.prefixTextStyle,
    this.versionTextStyle,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    super.key,
  });

  /// The name of the company or developer organization (e.g., 'NanoDevs').
  final String companyName;

  /// Optional prefix label before [companyName]
  /// (e.g., 'Desenvolvido por' or 'Powered by').
  final String? prefix;

  /// Optional version or build identifier (e.g., 'v1.0.0').
  ///
  /// When null, [NanoPoweredBy] automatically resolves the application version
  /// natively from the host platform or from the `pubspec.yaml` asset fallback
  /// via [NanoAppInfo].
  final String? version;

  /// Optional logo widget representing the developer organization.
  final Widget? logo;

  /// Optional callback invoked when the branding widget is tapped.
  final VoidCallback? onTap;

  /// Whether to arrange elements in a single horizontal row (`true`)
  /// or vertically centered (`false`, default).
  final bool isCompact;

  /// Custom text style for [companyName].
  final TextStyle? companyTextStyle;

  /// Custom text style for [prefix].
  final TextStyle? prefixTextStyle;

  /// Custom text style for [version].
  final TextStyle? versionTextStyle;

  /// Alignment along the main axis. Defaults to [MainAxisAlignment.center].
  final MainAxisAlignment mainAxisAlignment;

  /// Alignment along the cross axis. Defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment crossAxisAlignment;

  /// Padding around the content.
  /// Defaults to `EdgeInsets.symmetric(horizontal: 16, vertical: 12)`.
  final EdgeInsetsGeometry padding;

  @override
  State<NanoPoweredBy> createState() => _NanoPoweredByState();
}

class _NanoPoweredByState extends State<NanoPoweredBy> {
  String? _resolvedVersion;

  @override
  void initState() {
    super.initState();
    _resolveVersion();
  }

  @override
  void didUpdateWidget(NanoPoweredBy oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.version != oldWidget.version) _resolveVersion();
  }

  void _resolveVersion() {
    if (widget.version != null) {
      _resolvedVersion = widget.version;
      return;
    }

    final cached = NanoAppInfo.cachedVersion;
    if (cached != null) {
      _resolvedVersion = cached;
      return;
    }

    NanoAppInfo.getVersion().then((version) {
      if (mounted && version != null && widget.version == null) {
        setState(() => _resolvedVersion = version);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectivePrefixStyle =
        widget.prefixTextStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
        );

    final effectiveCompanyStyle =
        widget.companyTextStyle ??
        (widget.isCompact
            ? theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              )
            : theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ));

    final effectiveVersionStyle =
        widget.versionTextStyle ??
        theme.textTheme.labelSmall?.copyWith(
          color: theme.textTheme.labelSmall?.color?.withValues(alpha: 0.5),
        );

    final Widget content;
    final displayVersion = widget.version ?? _resolvedVersion;

    if (widget.isCompact) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          if (widget.logo != null) ...[widget.logo!, const SizedBox(width: 8)],
          if (widget.prefix != null && widget.prefix!.trim().isNotEmpty) ...[
            Text(widget.prefix!, style: effectivePrefixStyle),
            const SizedBox(width: 4),
          ],
          Text(widget.companyName, style: effectiveCompanyStyle),
          if (displayVersion != null && displayVersion.trim().isNotEmpty) ...[
            Text(' • $displayVersion', style: effectiveVersionStyle),
          ],
        ],
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          if (widget.logo != null) ...[widget.logo!, const SizedBox(height: 8)],
          if (widget.prefix != null && widget.prefix!.trim().isNotEmpty) ...[
            Text(widget.prefix!, style: effectivePrefixStyle),
            const SizedBox(height: 2),
          ],
          Text(widget.companyName, style: effectiveCompanyStyle),
          if (displayVersion != null && displayVersion.trim().isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(displayVersion, style: effectiveVersionStyle),
          ],
        ],
      );
    }

    final padded = Padding(padding: widget.padding, child: content);

    if (widget.onTap == null) {
      return padded;
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onTap,
        child: padded,
      ),
    );
  }
}
