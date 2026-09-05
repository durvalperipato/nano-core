import 'package:flutter/material.dart';
import '../pagination/nano_paginator.dart';

/// A reactive pagination navigation control bar that binds to a [NanoPaginator]
/// with full UI customizability for next/previous buttons, page labels, and
/// dynamic page size selection.
class NanoPaginationBar<T> extends StatelessWidget {
  /// Creates a [NanoPaginationBar] widget.
  const NanoPaginationBar({
    required this.paginator,
    this.previousBuilder,
    this.nextBuilder,
    this.pageLabelBuilder,
    this.pageSizeSelectorBuilder,
    this.availablePageSizes = const [5, 10, 20, 50],
    this.showPageSizeSelector = false,
    this.builder,
    this.onPrevious,
    this.onNext,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    super.key,
  });

  /// The paginator driving the pagination state and actions.
  final NanoPaginator<T> paginator;

  /// Custom builder for the "Previous" button.
  final Widget Function(
    BuildContext context,
    VoidCallback? onPrevious,
    bool hasPrevious,
  )?
  previousBuilder;

  /// Custom builder for the "Next" button.
  final Widget Function(
    BuildContext context,
    VoidCallback? onNext,
    bool hasNext,
  )?
  nextBuilder;

  /// Custom builder for the page indicator label.
  final Widget Function(BuildContext context, int currentPage)?
  pageLabelBuilder;

  /// Custom builder for the page size selector.
  final Widget Function(
    BuildContext context,
    int currentSize,
    ValueChanged<int> onSizeChanged,
  )?
  pageSizeSelectorBuilder;

  /// Available options for page size (defaults to `[5, 10, 20, 50]`).
  final List<int> availablePageSizes;

  /// Whether to display a page size dropdown selector.
  final bool showPageSizeSelector;

  /// Optional full custom builder taking the [NanoPaginator] instance directly.
  final Widget Function(BuildContext context, NanoPaginator<T> paginator)?
  builder;

  /// Optional callback invoked when the previous page is requested.
  final VoidCallback? onPrevious;

  /// Optional callback invoked when the next page is requested.
  final VoidCallback? onNext;

  /// Alignment of the controls along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// Padding around the pagination bar.
  final EdgeInsetsGeometry padding;

  void _handlePrevious() {
    onPrevious?.call();
    paginator.previousPage();
  }

  void _handleNext() {
    onNext?.call();
    paginator.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: paginator,
      builder: (context, _) {
        if (builder != null) {
          return builder!(context, paginator);
        }

        final canGoPrevious = paginator.hasPrevious && !paginator.isLoading;
        final canGoNext =
            paginator.hasNext &&
            !paginator.isLoading &&
            !paginator.isLoadingNext;

        final previousWidget =
            previousBuilder?.call(
              context,
              canGoPrevious ? _handlePrevious : null,
              paginator.hasPrevious,
            ) ??
            OutlinedButton.icon(
              icon: const Icon(Icons.chevron_left, size: 18),
              label: const Text('Previous'),
              onPressed: canGoPrevious ? _handlePrevious : null,
            );

        final nextWidget =
            nextBuilder?.call(
              context,
              canGoNext ? _handleNext : null,
              paginator.hasNext,
            ) ??
            FilledButton.icon(
              icon: const Icon(Icons.chevron_right, size: 18),
              label: const Text('Next'),
              onPressed: canGoNext ? _handleNext : null,
            );

        final labelWidget =
            pageLabelBuilder?.call(context, paginator.currentPage) ??
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Page ${paginator.currentPage}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            );

        Widget? sizeSelectorWidget;
        if (showPageSizeSelector) {
          final currentSize = paginator.pageSize;
          final effectiveValue = availablePageSizes.contains(currentSize)
              ? currentSize
              : availablePageSizes.first;

          sizeSelectorWidget =
              pageSizeSelectorBuilder?.call(
                context,
                currentSize,
                paginator.changePageSize,
              ) ??
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Size:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 6),
                    DropdownButton<int>(
                      value: effectiveValue,
                      isDense: true,
                      underline: const SizedBox.shrink(),
                      items: availablePageSizes.map((size) {
                        return DropdownMenuItem<int>(
                          value: size,
                          child: Text(
                            '$size',
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: paginator.isLoading
                          ? null
                          : (newSize) {
                              if (newSize != null) {
                                paginator.changePageSize(newSize);
                              }
                            },
                    ),
                  ],
                ),
              );
        }

        return Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              previousWidget,
              labelWidget,
              nextWidget,
              ?sizeSelectorWidget,
            ],
          ),
        );
      },
    );
  }
}
