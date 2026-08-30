import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../../../../mocks/mock_models.dart';

/// Page displaying detailed information for a specific user.
class UserDetailPage extends StatelessWidget {
  /// The user model passed directly from route builder.
  final MockUser? user;

  /// Creates a [UserDetailPage] widget.
  const UserDetailPage({this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.name ?? 'User Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.back(),
        ),
      ),
      body: user == null
          ? const Center(child: Text('No user data provided.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: const Color(0xFF6366F1),
                      child: Text(
                        user!.name.isNotEmpty
                            ? user!.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user!.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user!.email,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 24),
                          _DetailRow(
                            label: 'User ID',
                            value: user!.id,
                            icon: Icons.tag,
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(
                            label: 'Email',
                            value: user!.email,
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 12),
                          const _DetailRow(
                            label: 'Status',
                            value: 'Active (Nano Entity)',
                            icon: Icons.verified_user_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        NanoToast.showSuccess(
                          context,
                          'Action executed for ${user!.name}!',
                        );
                      },
                      icon: const Icon(Icons.bolt),
                      label: const Text('Execute Nano Action'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6366F1)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
