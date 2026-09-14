import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import 'section_header.dart';

/// Card component demonstrating NanoSkeleton and NanoShimmer loading placeholders.
class SkeletonAndShimmerCard extends StatefulWidget {
  /// Creates a [SkeletonAndShimmerCard] widget.
  const SkeletonAndShimmerCard({super.key});

  @override
  State<SkeletonAndShimmerCard> createState() => _SkeletonAndShimmerCardState();
}

class _SkeletonAndShimmerCardState extends State<SkeletonAndShimmerCard> {
  int _selectedPresetIndex = 0;
  bool _isMaskLoading = true;
  NanoShimmerDirection _shimmerDirection = NanoShimmerDirection.ltr;

  static const List<String> _presets = ['List', 'Card', 'Grid', 'Primitives'];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.auto_awesome,
              title: 'Skeleton & Shimmer Loading (v1.0.6)',
              subtitle:
                  'Native GPU-accelerated placeholders and wave shimmer '
                  'with zero external dependencies',
            ),
            const SizedBox(height: 16),

            // Controls Row: Shimmer Direction & Ghost Masking Toggle
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DropdownButton<NanoShimmerDirection>(
                  value: _shimmerDirection,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  underline: const SizedBox.shrink(),
                  onChanged: (val) {
                    if (val != null) setState(() => _shimmerDirection = val);
                  },
                  items: NanoShimmerDirection.values.map((dir) {
                    return DropdownMenuItem(
                      value: dir,
                      child: Text('Direction: ${dir.name.toUpperCase()}'),
                    );
                  }).toList(),
                ),
                FilterChip(
                  label: Text(
                    _isMaskLoading ? 'Ghost Mask: ON' : 'Ghost Mask: OFF',
                  ),
                  selected: _isMaskLoading,
                  onSelected: (val) => setState(() => _isMaskLoading = val),
                  selectedColor: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  checkmarkColor: const Color(0xFF6366F1),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Preset Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_presets.length, (index) {
                  final isSelected = _selectedPresetIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_presets[index]),
                      selected: isSelected,
                      selectedColor: const Color(0xFF6366F1),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedPresetIndex = index),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Preset Preview Canvas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: _buildPresetContent(),
            ),
            const SizedBox(height: 16),

            // Ghost Mask Demonstration
            const Text(
              'Interactive NanoSkeleton.mask():',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: NanoSkeleton.mask(
                loading: _isMaskLoading,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF6366F1),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: const Text(
                    'Durval Peripato Neto',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Staff Flutter Architect • Nano Ecosystem',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                    ),
                    child: const Text('View Profile'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetContent() {
    switch (_selectedPresetIndex) {
      case 0:
        return NanoShimmer(
          direction: _shimmerDirection,
          child: NanoSkeleton.list(items: 3, spacing: 12),
        );
      case 1:
        return NanoShimmer(
          direction: _shimmerDirection,
          child: NanoSkeleton.card(height: 120),
        );
      case 2:
        return SizedBox(
          height: 160,
          child: NanoShimmer(
            direction: _shimmerDirection,
            child: NanoSkeleton.grid(
              columns: 3,
              rows: 2,
              itemHeight: 70,
              spacing: 8,
            ),
          ),
        );
      case 3:
      default:
        return NanoShimmer(
          direction: _shimmerDirection,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  NanoSkeleton.circle(size: 48),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NanoSkeleton.box(width: 160, height: 16),
                        SizedBox(height: 8),
                        NanoSkeleton.box(width: 100, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              NanoSkeleton.box(width: double.infinity, height: 32),
            ],
          ),
        );
    }
  }
}
