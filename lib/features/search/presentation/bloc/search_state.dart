part of 'search_bloc.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  final List<SearchHistoryEntity>? history;

  const SearchInitial({this.history});
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchResultEntity results;
  final String query;
  final int currentPage;
  final bool isLoadingMore;

  const SearchLoaded({
    required this.results,
    required this.query,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  SearchLoaded copyWith({
    SearchResultEntity? results,
    String? query,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return SearchLoaded(
      results: results ?? this.results,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});
}


