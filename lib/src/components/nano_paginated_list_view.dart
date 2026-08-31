import 'package:flutter/material.dart';
import '../pagination/nano_paginator.dart';

/// A reactive [ListView] that automatically binds to a [NanoPaginator] to
/// handle infinite scrolling, bottom loading indicators, and pull-to-refresh.
class NanoPaginatedListView<T> extends StatefulWidget {
  /// Creates a [NanoPaginatedListView] widget.
  const NanoPaginatedListView({
    required this.paginator,
    required this.itemBuilder,
    this.separatorBuilder,
    this.emptyWidget,
    this.loadingWidget,
    this.errorBuilder,
    this.nextLoadingWidget,
    this.scrollThreshold = 200.0,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.enablePullToRefresh = true,
    this.scrollController,
    super.key,
  });

  /// The paginator driving the list state and pagination calls.
  final NanoPaginator<T> paginator;

  /// Builder for rendering each item in the list.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Optional separator between items.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Widget displayed when the list is empty and not loading.
  final Widget? emptyWidget;

  /// Widget displayed during the initial full page load.
  final Widget? loadingWidget;

  /// Builder displayed when an error occurs.
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  /// Spinner widget displayed at the bottom while fetching subsequent pages.
  final Widget? nextLoadingWidget;

  /// Distance in pixels from the bottom of the scroll view before triggering
  /// [NanoPaginator.loadNextPage].
  final double scrollThreshold;

  /// Padding applied around the scrollable content.
  final EdgeInsetsGeometry padding;

  /// Scroll physics for the list.
  final ScrollPhysics? physics;

  /// Whether pull-to-refresh is enabled.
  final bool enablePullToRefresh;

  /// Optional custom [ScrollController].
  final ScrollController? scrollController;

  @override
  State<NanoPaginatedListView<T>> createState() =>
      _NanoPaginatedListViewState<T>();
}

class _NanoPaginatedListViewState<T> extends State<NanoPaginatedListView<T>> {
  late ScrollController _scrollController;
  bool _createdInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
    } else {
      _scrollController = ScrollController();
      _createdInternalController = true;
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (_createdInternalController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= widget.scrollThreshold) {
      widget.paginator.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.paginator,
      builder: (context, _) {
        final paginator = widget.paginator;

        if (paginator.isLoading && paginator.items.isEmpty) {
          return widget.loadingWidget ??
              const Center(child: CircularProgressIndicator());
        }

        if (paginator.error != null && paginator.items.isEmpty) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(context, paginator.error!);
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text('Failed to load: ${paginator.error}'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: paginator.refresh,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (paginator.items.isEmpty) {
          return widget.emptyWidget ??
              const Center(child: Text('No items found.'));
        }

        final count = paginator.items.length + (paginator.hasNext ? 1 : 0);

        Widget list = ListView.separated(
          controller: _scrollController,
          padding: widget.padding,
          physics: widget.physics,
          itemCount: count,
          separatorBuilder: (context, index) {
            if (index >= paginator.items.length) return const SizedBox.shrink();
            return widget.separatorBuilder?.call(context, index) ??
                const SizedBox.shrink();
          },
          itemBuilder: (context, index) {
            if (index == paginator.items.length) {
              return widget.nextLoadingWidget ??
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  );
            }

            final item = paginator.items[index];
            return widget.itemBuilder(context, item, index);
          },
        );

        if (widget.enablePullToRefresh) {
          list = RefreshIndicator(
            onRefresh: paginator.refresh,
            child: list,
          );
        }

        return list;
      },
    );
  }
}
