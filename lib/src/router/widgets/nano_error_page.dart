import 'package:flutter/material.dart';
import '../models/nano_route_error.dart';

/// The default error and not-found page displayed by [NanoRouter].
class NanoErrorPage extends StatelessWidget {
  /// Creates a [NanoErrorPage] widget.
  const NanoErrorPage({required this.error, this.errorBuilder, super.key});

  /// The route error payload.
  final NanoRouteError error;

  /// Optional custom error builder.
  final Widget Function(BuildContext context, NanoRouteError error)?
  errorBuilder;

  @override
  Widget build(BuildContext context) {
    final customBuilder = errorBuilder;
    if (customBuilder != null) {
      return customBuilder(context, error);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                '404 - Not Found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'The requested route "${error.path}" could not be found.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
