import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/search/data/models/search_result_model.dart';
import 'package:social_app_fe/features/search/domain/entities/search_history_entity.dart';
import 'package:social_app_fe/features/search/domain/entities/search_result_entity.dart';
import 'package:social_app_fe/features/search/domain/usecases/get_search_history_usecase.dart';
import 'package:social_app_fe/features/search/domain/usecases/search_users_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUsersUseCase searchUsersUseCase;
  final GetSearchHistoryUseCase getSearchHistoryUseCase;
  String? _currentSearchQuery;

  SearchBloc({
    required this.searchUsersUseCase,
    required this.getSearchHistoryUseCase,
  }) : super(const SearchInitial()) {
    on<SearchUsers>(_onSearchUsers);
    on<LoadMoreResults>(_onLoadMoreResults);
    on<ClearSearch>(_onClearSearch);
    on<LoadSearchHistory>(_onLoadSearchHistory);
    
    // Tự động load lịch sử khi khởi tạo
    add(const LoadSearchHistory(limit: 10));
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      _currentSearchQuery = null;
      emit(SearchInitial());
      return;
    }

    // Lưu query hiện tại đang được xử lý
    _currentSearchQuery = event.query;
    emit(SearchLoading());

    final dataState = await searchUsersUseCase(
      query: event.query,
      page: 1,
      limit: event.limit,
    );

    // Chỉ emit kết quả nếu query vẫn còn là query hiện tại (tránh race condition)
    if (_currentSearchQuery == event.query) {
      if (dataState is DataStateSuccess) {
        emit(SearchLoaded(
          results: dataState.data!,
          query: event.query,
          currentPage: 1,
        ));
      } else if (dataState is DataStateError) {
        emit(SearchError(
          message: dataState.error?.message ?? 'Lỗi tìm kiếm',
        ));
      }
    }
  }

  Future<void> _onLoadMoreResults(
    LoadMoreResults event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SearchLoaded) return;

    if (!currentState.results.pagination.hasNextPage) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final dataState = await searchUsersUseCase(
      query: currentState.query,
      page: currentState.currentPage + 1,
      limit: event.limit,
    );

    if (dataState is DataStateSuccess) {
      final newResults = dataState.data!;
      
      // Kiểm tra xem newResults có phải là SearchResultModel không
      if (newResults is SearchResultModel) {
        final currentResults = currentState.results;
        if (currentResults is SearchResultModel) {
          final combinedUsers = [
            ...currentResults.userResponseDtos,
            ...newResults.userResponseDtos,
          ];

          // Tạo SearchResult mới với danh sách kết hợp
          final updatedResults = SearchResultModel(
            userResponseDtos: combinedUsers,
            pagination: newResults.pagination,
          );

          emit(SearchLoaded(
            results: updatedResults,
            query: currentState.query,
            currentPage: currentState.currentPage + 1,
          ));
        } else {
          // Fallback: chỉ thêm kết quả mới nếu không thể combine
          emit(SearchLoaded(
            results: newResults,
            query: currentState.query,
            currentPage: currentState.currentPage + 1,
          ));
        }
      } else {
        // Nếu không phải SearchResultModel, chỉ emit kết quả mới
        emit(SearchLoaded(
          results: newResults,
          query: currentState.query,
          currentPage: currentState.currentPage + 1,
        ));
      }
    } else if (dataState is DataStateError) {
      emit(currentState.copyWith(isLoadingMore: false));
      emit(SearchError(
        message: dataState.error?.message ?? 'Lỗi tải thêm kết quả',
      ));
    }
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) {
    _currentSearchQuery = null;
    // Load lại lịch sử khi clear search
    add(const LoadSearchHistory(limit: 10));
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    final dataState = await getSearchHistoryUseCase(limit: event.limit);

    if (dataState is DataStateSuccess) {
      emit(SearchInitial(history: dataState.data));
    } else {
      // Nếu lỗi, vẫn emit initial state nhưng không có history
      emit(const SearchInitial());
    }
  }
}

