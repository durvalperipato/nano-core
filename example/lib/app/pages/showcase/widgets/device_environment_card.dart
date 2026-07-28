import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'section_header.dart';
import 'status_badge.dart';

/// Card component displaying live NanoDeviceType environment detection.
class DeviceEnvironmentCard extends StatelessWidget {
  const DeviceEnvironmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = NanoDeviceType.isDesktop(context);
    final isMobile = NanoDeviceType.isMobile(context);
    final deviceType = NanoDeviceType.fromContext(context);
    final width = MediaQuery.of(context).size.width.toInt();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.devices,
              title: 'NanoDeviceType Environment Detection',
              subtitle: 'Real-time screen and platform environment inspection',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                StatusBadge(
                  label: 'Desktop Layout',
                  isActive: isDesktop,
                  color: const Color(0xFF6366F1),
                ),
                StatusBadge(
                  label: 'Mobile Layout',
                  isActive: isMobile,
                  color: const Color(0xFFF59E0B),
                ),
                StatusBadge(
                  label: 'Active: ${deviceType.name.toUpperCase()}',
                  isActive: true,
                  color: const Color(0xFF10B981),
                ),
                StatusBadge(
                  label: 'Width: ${width}px',
                  isActive: true,
                  color: const Color(0xFF38BDF8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
