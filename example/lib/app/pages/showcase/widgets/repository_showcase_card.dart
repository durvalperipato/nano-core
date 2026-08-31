import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../../../mocks/mock_models.dart';
import 'section_header.dart';

/// Card showcasing [NanoRepository] and [NanoSearchRepository] with live URL inspection.
class RepositoryShowcaseCard extends StatefulWidget {
  /// Creates a [RepositoryShowcaseCard] widget.
  const RepositoryShowcaseCard({super.key});

  @override
  State<RepositoryShowcaseCard> createState() => _RepositoryShowcaseCardState();
}

class _RepositoryShowcaseCardState extends State<RepositoryShowcaseCard> {
  final _searchController = TextEditingController(text: 'Alice');
  String _selectedRole = 'all';
  bool _isLoading = false;
  String _lastUrl = 'GET /users?name=Alice';
  List<MockUser> _results = const [];

  late final MockUserSearchRepository _searchRepository;

  @override
  void initState() {
    super.initState();
    _searchRepository = MockUserSearchRepository();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _buildSimulatedUrl(MockUserFilter filter) {
    final adapter = const MockUserFilterAdapter();
    final queryParams = adapter.toQueryParams(filter);
    if (queryParams.isEmpty) return 'GET /users';

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    return 'GET /users?$queryString';
  }

  Future<void> _executeSearch() async {
    setState(() => _isLoading = true);

    final name = _searchController.text.trim();
    final filter = MockUserFilter(
      name: name.isNotEmpty ? name : null,
      role: _selectedRole != 'all' ? _selectedRole : null,
    );

    final url = _buildSimulatedUrl(filter);

    try {
      final users = await _searchRepository.search(filter);
      if (!mounted) return;

      setState(() {
        _lastUrl = url;
        _results = users;
        _isLoading = false;
      });

      NanoToast.showSuccess(
        context,
        'Request: $url\nFound ${users.length} user(s)',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      NanoToast.showError(context, 'Failed to fetch: $e');
    }
  }

  Future<void> _executeGetAll() async {
    setState(() => _isLoading = true);
    const url = 'GET /users';

    try {
      final users = await _searchRepository.getAll();
      if (!mounted) return;

      setState(() {
        _lastUrl = url;
        _results = users;
        _isLoading = false;
      });

      NanoToast.showSuccess(
        context,
        'Request: $url\nFound ${users.length} user(s)',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      NanoToast.showError(context, 'Failed to fetch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.storage_outlined,
              title: 'Repository & Type-Safe Search',
              subtitle:
                  'Typed query adapters with live URL parameters inspection',
            ),
            const SizedBox(height: 16),

            // Live Network Inspector box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'HTTP URL INSPECTOR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (_isLoading)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    _lastUrl,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: Color(0xFF38BDF8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Filter controls
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Filter by Name (MockUserFilter.name)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  'Role Filter:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedRole == 'all',
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedRole = 'all');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Admin'),
                  selected: _selectedRole == 'admin',
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedRole = 'admin');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Developer'),
                  selected: _selectedRole == 'developer',
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedRole = 'developer');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.travel_explore, size: 18),
                  label: const Text('Search (NanoSearchRepository)'),
                  onPressed: _isLoading ? null : _executeSearch,
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.list_alt, size: 18),
                  label: const Text('Get All (NanoRepository)'),
                  onPressed: _isLoading ? null : _executeGetAll,
                ),
              ],
            ),

            if (_results.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Results (${_results.length} items):',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._results.map(
                (user) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${user.name} (${user.email})',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
