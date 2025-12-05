part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

class SearchUsers extends SearchEvent {
  final String query;
  final int limit;

  const SearchUsers({
    required this.query,
    this.limit = 10,
  });
}

class LoadMoreResults extends SearchEvent {
  final int limit;

  const LoadMoreResults({this.limit = 10});
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

