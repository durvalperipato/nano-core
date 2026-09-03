import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'nano_cursor_pagination.dart';
import 'nano_offset_pagination.dart';
import 'nano_paginated_result.dart';
import 'nano_pagination.dart';

/// Signature for asynchronous page fetching functions returning either a
/// [NanoPaginatedResult] or a raw [List].
typedef NanoPageFetcher<T> = FutureOr<dynamic> Function(
  NanoPagination pagination,
);

/// A stateful pagination controller that manages page loading, accumulated
/// items, next-page progression, total counts, and loading/error states.
class NanoPaginator<T> extends ChangeNotifier {
  /// Creates a [NanoPaginator] instance.
  NanoPaginator({
    required this.fetcher,
    NanoPagination? initialPagination,
  }) : _currentPagination = initialPagination ??
            (GetIt.I.isRegistered<NanoPagination>()
                ? GetIt.I<NanoPagination>()
                : const NanoOffsetPagination());

  /// The delegate function called to retrieve each page of data.
  final NanoPageFetcher<T> fetcher;

  NanoPagination _currentPagination;

  /// The active pagination strategy.
  NanoPagination get currentPagination => _currentPagination;

  List<T> _items = const [];

  /// The accumulated list of fetched items.
  List<T> get items => List.unmodifiable(_items);

  int? _totalCount;

  /// Total count of items reported by the server, if available.
  int? get totalCount => _totalCount;

  int? _totalPages;

  /// Total number of pages reported by the server, if available.
  int? get totalPages => _totalPages;

  bool _isLoading = false;

  /// Whether the initial page or a full refresh is currently loading.
  bool get isLoading => _isLoading;

  bool _isLoadingNext = false;

  /// Whether subsequent pages are currently being appended.
  bool get isLoadingNext => _isLoadingNext;

  bool _hasNext = true;

  /// Whether more items are available on subsequent pages.
  bool get hasNext => _hasNext;

  /// Whether a previous page exists (currentPage > 1).
  bool get hasPrevious => currentPage > 1;

  Object? _error;

  /// The error encountered during the last fetch, if any.
  Object? get error => _error;

  /// The current page number when using [NanoOffsetPagination].
  int get currentPage {
    final p = _currentPagination;
    if (p is NanoOffsetPagination) return p.page;
    return 1;
  }

  /// The current page size / limit.
  int get pageSize {
    final p = _currentPagination;
    if (p is NanoOffsetPagination) return p.pageSize;
    if (p is NanoCursorPagination) return p.limit;
    return 20;
  }

  /// Updates the page size and reloads the first page.
  Future<void> changePageSize(int newSize) async {
    if (newSize < 1) return;
    if (_currentPagination is NanoOffsetPagination) {
      final offset = _currentPagination as NanoOffsetPagination;
      _currentPagination = offset.copyWith(pageSize: newSize, page: 1);
    } else if (_currentPagination is NanoCursorPagination) {
      final cursor = _currentPagination as NanoCursorPagination;
      _currentPagination = cursor.copyWith(limit: newSize, cursor: '');
    }
    await loadFirstPage();
  }

  /// Fetches the first page and replaces the accumulated items list.
  Future<void> loadFirstPage() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (_currentPagination is NanoOffsetPagination) {
      final offset = _currentPagination as NanoOffsetPagination;
      _currentPagination = offset.copyWith(page: 1);
    } else if (_currentPagination is NanoCursorPagination) {
      final cursor = _currentPagination as NanoCursorPagination;
      _currentPagination = cursor.copyWith(cursor: '');
    }

    try {
      final response = await fetcher(_currentPagination);
      _handleResponse(response, isNextPage: false);
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches the next page and appends the new items to the list.
  Future<void> loadNextPage() async {
    if (_isLoading || _isLoadingNext || !_hasNext) return;

    _isLoadingNext = true;
    _error = null;
    notifyListeners();

    if (_currentPagination is NanoOffsetPagination) {
      final offset = _currentPagination as NanoOffsetPagination;
      _currentPagination = offset.copyWith(page: offset.page + 1);
    }

    try {
      final response = await fetcher(_currentPagination);
      _handleResponse(response, isNextPage: true);
    } catch (e) {
      _error = e;
    } finally {
      _isLoadingNext = false;
      notifyListeners();
    }
  }

  /// Navigates to a specific page number (for page/table-based views).
  Future<void> goToPage(int page) async {
    if (page < 1 || _isLoading || _isLoadingNext) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    if (_currentPagination is NanoOffsetPagination) {
      final offset = _currentPagination as NanoOffsetPagination;
      _currentPagination = offset.copyWith(page: page);
    }

    try {
      final response = await fetcher(_currentPagination);
      _handleResponse(response, isNextPage: false);
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Navigates to the previous page if available.
  Future<void> previousPage() async {
    if (!hasPrevious) return;
    await goToPage(currentPage - 1);
  }

  /// Navigates to the next page.
  Future<void> nextPage() => loadNextPage();

  void _handleResponse(dynamic response, {required bool isNextPage}) {
    List<T> newItems;
    bool? explicitHasNext;
    String? nextCursor;

    if (response is NanoPaginatedResult<T>) {
      newItems = response.items;
      _totalCount = response.totalCount ?? _totalCount;
      _totalPages = response.totalPages ?? _totalPages;
      explicitHasNext = response.hasNext;
      nextCursor = response.nextCursor;
    } else if (response is NanoPaginatedResult<dynamic>) {
      newItems = response.items.cast<T>();
      _totalCount = response.totalCount ?? _totalCount;
      _totalPages = response.totalPages ?? _totalPages;
      explicitHasNext = response.hasNext;
      nextCursor = response.nextCursor;
    } else if (response is List<T>) {
      newItems = response;
    } else if (response is List) {
      newItems = response.cast<T>();
    } else {
      newItems = const [];
    }

    if (isNextPage) {
      _items = [..._items, ...newItems];
    } else {
      _items = List.from(newItems);
    }

    if (explicitHasNext != null) {
      _hasNext = explicitHasNext;
    } else {
      final p = _currentPagination;
      if (p is NanoOffsetPagination) {
        _hasNext = newItems.length >= p.pageSize;
      } else if (p is NanoCursorPagination) {
        _hasNext = newItems.length >= p.limit;
      }
    }

    if (nextCursor != null && _currentPagination is NanoCursorPagination) {
      final cursor = _currentPagination as NanoCursorPagination;
      _currentPagination = cursor.copyWith(cursor: nextCursor);
    }
  }

  /// Reloads the first page from scratch.
  Future<void> refresh() => loadFirstPage();

  /// Clears all items and resets pagination state.
  void clear() {
    _items = const [];
    _totalCount = null;
    _totalPages = null;
    _hasNext = true;
    _error = null;
    notifyListeners();
  }
}
