import 'package:flutter/material.dart';

/// Reusable section header component for showcase cards.
class SectionHeader extends StatelessWidget {
  /// Header icon.
  final IconData icon;

  /// Main title string.
  final String title;

  /// Subtitle description string.
  final String subtitle;

  /// Creates a [SectionHeader] widget.
  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6366F1), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
