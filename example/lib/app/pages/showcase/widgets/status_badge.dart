import 'package:flutter/material.dart';

/// Reusable status badge component for environment indicators.
class StatusBadge extends StatelessWidget {
  /// Badge label string.
  final String label;

  /// Whether the status is active.
  final bool isActive;

  /// Theme accent color for the badge.
  final Color color;

  /// Creates a [StatusBadge] widget.
  const StatusBadge({
    required this.label,
    required this.isActive,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.15) : Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.4) : Colors.white24,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
