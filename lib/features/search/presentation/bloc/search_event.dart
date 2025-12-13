part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

class SearchUsers extends SearchEvent {
  final String query;
  final int limit;
  final bool saveToHistory;

  const SearchUsers({
    required this.query,
    this.limit = 10,
    this.saveToHistory = true,
  });
}

class LoadMoreResults extends SearchEvent {
  final int limit;

  const LoadMoreResults({this.limit = 10});
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

class LoadSearchHistory extends SearchEvent {
  final int limit;

  const LoadSearchHistory({this.limit = 10});
}

class DeleteSearchHistory extends SearchEvent {
  final String historyId;

  const DeleteSearchHistory({required this.historyId});
}

class ClearAllSearchHistory extends SearchEvent {
  const ClearAllSearchHistory();
}
