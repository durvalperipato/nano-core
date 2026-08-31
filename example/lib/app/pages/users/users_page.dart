import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../../core/routes/app_route_names.dart';
import '../../mocks/mock_models.dart';
import 'users_controller.dart';
import 'users_injections.dart';
import 'users_state.dart';

/// Page displaying a list of users fetched from the repository.
class UsersPage extends StatefulWidget {
  /// Creates a [UsersPage] widget.
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends NanoStatePage<UsersPage, UsersController> {
  @override
  NanoInjections get injections => UsersInjections();

  @override
  Widget build(BuildContext context) {
    return NanoScaffold<UsersState, NanoMessageKey>(
      controller: controller,
      headerBuilder: (context, state) => AppBar(
        title: Text(
          state.data?.users.isNotEmpty == true
              ? 'Users (${state.data!.users.length})'
              : 'Users List',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Users',
            onPressed: controller.fetchUsers,
          ),
        ],
      ),
      builder: (context, state) {
        final users = state.data?.users ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name (NanoSearchRepository)...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => controller.fetchUsers(),
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: controller.searchUsers,
                onChanged: (value) {
                  if (value.isEmpty) {
                    controller.fetchUsers();
                  }
                },
              ),
            ),
            Expanded(
              child: users.isEmpty && state is! LoadingState
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_search,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          const Text('No users match this filter.'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: controller.fetchUsers,
                            child: const Text('Reset Filter'),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: users.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _UserCard(
                          user: user,
                          onTap: () {
                            context.toNamed(
                              AppRouteNames.userDetail,
                              arguments: {'user': user},
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.onTap});

  final MockUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(user.email),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
