import 'package:flutter/material.dart';
import 'package:nano_core/nano_core.dart';
import '../../../mocks/mock_models.dart';
import 'section_header.dart';

/// Card showcasing [NanoRepository], [NanoSearchRepository], [NanoPaginator],
/// and [NanoCache] with live URL inspection, cache policies, and pagination.
class RepositoryShowcaseCard extends StatefulWidget {
  /// Creates a [RepositoryShowcaseCard] widget.
  const RepositoryShowcaseCard({super.key});

  @override
  State<RepositoryShowcaseCard> createState() => _RepositoryShowcaseCardState();
}

class _RepositoryShowcaseCardState extends State<RepositoryShowcaseCard> {
  final _searchController = TextEditingController(text: '');
  String _selectedRole = 'all';
  NanoCachePolicy _selectedPolicy = NanoCachePolicy.cacheFirst;
  bool _isLoading = false;
  String _lastUrl = 'GET /users?page=1&pageSize=4';
  String _lastLatency = '';

  late final MockUserSearchRepository _searchRepository;
  late final NanoPaginator<MockUser> _paginator;

  @override
  void initState() {
    super.initState();
    _searchRepository = MockUserSearchRepository();
    _paginator = NanoPaginator<MockUser>(
      initialPagination: const NanoOffsetPagination(page: 1, pageSize: 4),
      fetcher: (pagination) async {
        final filter = MockUserFilter(
          name: _searchController.text.trim().isNotEmpty
              ? _searchController.text.trim()
              : null,
          role: _selectedRole != 'all' ? _selectedRole : null,
        );

        final queryParams = const MockUserFilterAdapter().toQueryParams(filter);
        final paginationParams = pagination.toQueryParams();

        final allParams = {...queryParams, ...paginationParams};
        final queryString = allParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');

        final stopwatch = Stopwatch()..start();
        final users = await _searchRepository.search(
          filter,
          pagination: pagination,
          cachePolicy: _selectedPolicy,
        );
        stopwatch.stop();

        final latency = stopwatch.elapsedMilliseconds < 50
            ? '⚡ 0ms (Cache Hit)'
            : '🌐 ${stopwatch.elapsedMilliseconds}ms (Network)';

        setState(() {
          _lastUrl = 'GET /users?$queryString';
          _lastLatency = latency;
        });

        return users;
      },
    );
    _paginator.loadFirstPage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _paginator.dispose();
    super.dispose();
  }

  Future<void> _executeSearch() async {
    await _paginator.loadFirstPage();
  }

  Future<void> _executeGetAll() async {
    setState(() => _isLoading = true);
    const url = 'GET /users';
    final stopwatch = Stopwatch()..start();

    try {
      final users = await _searchRepository.getAll(cachePolicy: _selectedPolicy);
      stopwatch.stop();
      if (!mounted) return;

      final latency = stopwatch.elapsedMilliseconds < 50
          ? '⚡ 0ms (Cache Hit)'
          : '🌐 ${stopwatch.elapsedMilliseconds}ms (Network)';

      setState(() {
        _lastUrl = url;
        _lastLatency = latency;
        _isLoading = false;
      });

      NanoToast.showSuccess(
        context,
        'Request: $url\nFound ${users.length} user(s) [$latency]',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      NanoToast.showError(context, 'Failed to fetch: $e');
    }
  }

  void _invalidateCache() {
    _searchRepository.invalidateCache();
    NanoToast.showSuccess(context, 'Repository cache cleared!');
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
              title: 'Repository, Cache & NanoPaginator',
              subtitle:
                  'Cache policies (cacheFirst, networkOnly), TTL, and live latency',
            ),
            const SizedBox(height: 16),

            // Live Network & Cache Inspector box
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
                          color:
                              const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'HTTP & CACHE INSPECTOR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_lastLatency.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _lastLatency.contains('Cache')
                                ? const Color(0xFF38BDF8)
                                    .withValues(alpha: 0.2)
                                : const Color(0xFFF59E0B)
                                    .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _lastLatency,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _lastLatency.contains('Cache')
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      const Spacer(),
                      ListenableBuilder(
                        listenable: _paginator,
                        builder: (context, _) {
                          if (_paginator.isLoading ||
                              _paginator.isLoadingNext ||
                              _isLoading) {
                            return const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }
                          return const SizedBox.shrink();
                        },
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

            // Cache Policy Selector
            Row(
              children: [
                const Text(
                  'Cache Policy:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('cacheFirst'),
                  selected: _selectedPolicy == NanoCachePolicy.cacheFirst,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedPolicy = NanoCachePolicy.cacheFirst);
                    }
                  },
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('networkOnly'),
                  selected: _selectedPolicy == NanoCachePolicy.networkOnly,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedPolicy = NanoCachePolicy.networkOnly);
                    }
                  },
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('networkFirst'),
                  selected: _selectedPolicy == NanoCachePolicy.networkFirst,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedPolicy = NanoCachePolicy.networkFirst);
                    }
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: 'Invalidate Cache',
                  onPressed: _invalidateCache,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter controls
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Filter by Name (MockUserFilter.name)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _executeSearch();
                  },
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _executeSearch(),
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
                    if (selected) {
                      setState(() => _selectedRole = 'all');
                      _executeSearch();
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Admin'),
                  selected: _selectedRole == 'admin',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedRole = 'admin');
                      _executeSearch();
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Developer'),
                  selected: _selectedRole == 'developer',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedRole = 'developer');
                      _executeSearch();
                    }
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
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Filter / Reload (Page 1)'),
                  onPressed: _executeSearch,
                ),
                ListenableBuilder(
                  listenable: _paginator,
                  builder: (context, _) {
                    return FilledButton.tonalIcon(
                      icon: const Icon(Icons.arrow_downward, size: 18),
                      label: Text(
                        _paginator.hasNext
                            ? 'Next Page (Page ${_paginator.currentPage + 1})'
                            : 'No More Pages',
                      ),
                      onPressed: _paginator.hasNext
                          ? _paginator.loadNextPage
                          : null,
                    );
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.list_alt, size: 18),
                  label: const Text('Get All Unpaged'),
                  onPressed: _isLoading ? null : _executeGetAll,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Paginator Items Preview
            ListenableBuilder(
              listenable: _paginator,
              builder: (context, _) {
                final items = _paginator.items;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Accumulated Items (${items.length}):',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Page ${_paginator.currentPage} • Has next: ${_paginator.hasNext}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_paginator.isLoading && items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text('No users match this criteria.'),
                        ),
                      )
                    else ...[
                      ...items.map(
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
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  user.role,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_paginator.isLoadingNext)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      const Divider(),
                      NanoPaginationBar(
                        paginator: _paginator,
                        showPageSizeSelector: true,
                        availablePageSizes: const [2, 4, 8, 15],
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
