import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../../../mocks/mock_models.dart';
import '../showcase_controller.dart';
import 'section_header.dart';

/// Card component demonstrating NanoCommand and NanoCommandBuilder.
class NanoCommandCard extends StatelessWidget {
  /// Associated controller instance.
  final ShowcaseController controller;

  /// Creates a [NanoCommandCard] widget.
  const NanoCommandCard({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.touch_app,
              title: 'NanoCommand & NanoCommandBuilder',
              subtitle:
                  'Encapsulate asynchronous user actions with built-in '
                  'reactive state',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                _UserCommandSection(controller: controller),
                _CompaniesCommandSection(controller: controller),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCommandSection extends StatelessWidget {
  final ShowcaseController controller;

  const _UserCommandSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return NanoCommandBuilder<MockUser?>(
      command: controller.fetchUserCommand,
      builder: (context, state) {
        final isLoading = state is LoadingState;
        final data = state.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => controller.fetchUserCommand.run(),
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.person),
              label: Text(isLoading ? 'Fetching User...' : 'Fetch User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
              ),
            ),
            if (data != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'User: ${data.name}\nEmail: ${data.email}',
                  style: const TextStyle(
                    color: Color(0xFFA5B4FC),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _CompaniesCommandSection extends StatelessWidget {
  final ShowcaseController controller;

  const _CompaniesCommandSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return NanoCommandBuilder<List<MockCompany>>(
      command: controller.fetchCompaniesCommand,
      builder: (context, state) {
        final isLoading = state is LoadingState;
        final data = state.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => controller.fetchCompaniesCommand.run(),
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.business),
              label: Text(
                isLoading ? 'Fetching Companies...' : 'Fetch Companies',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
            ),
            if (data != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data
                      .map(
                        (company) => Text(
                          '🏢 ${company.name}',
                          style: const TextStyle(
                            color: Color(0xFF6EE7B7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
