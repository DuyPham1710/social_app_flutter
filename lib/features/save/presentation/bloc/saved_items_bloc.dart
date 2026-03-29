import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/save/domain/usecases/get_saved_items_usecase.dart';
import 'saved_items_event.dart';
import 'saved_items_state.dart';

class SavedItemsBloc extends Bloc<SavedItemsEvent, SavedItemsState> {
  final GetSavedItemsUsecase _getSavedItems;
  
  static const int _limit = 20;

  SavedItemsBloc(this._getSavedItems) : super(SavedItemsInitial()) {
    on<LoadSavedItems>(_onLoadSavedItems);
    on<ChangeCategoryTab>(_onChangeCategoryTab);
  }

  // Helper method to convert category name to API type
  String? _getTypeFromCategory(String category) {
    switch (category) {
      case 'Tất cả':
        return null;
      case 'Thước phim':
        return 'reel';
      case 'Bài viết':
        return 'post';
      case 'Bình luận':
        return 'comment';
      default:
        return null; // or perhaps handle collections specifically
    }
  }

  Future<void> _onLoadSavedItems(
    LoadSavedItems event,
    Emitter<SavedItemsState> emit,
  ) async {
    final currentState = state;
    String category = 'Tất cả';
    int page = 1;

    if (currentState is SavedItemsLoaded) {
      if (event.isRefresh) {
        category = currentState.currentCategory;
        // Keep loading visual trick if needed by emitting loading 
        // emit(SavedItemsLoading());
      } else {
        if (currentState.hasReachedMax) return;
        category = currentState.currentCategory;
        page = currentState.currentPage + 1;
      }
    } else {
      emit(SavedItemsLoading());
    }

    final dataState = await _getSavedItems(
      params: GetSavedItemsParams(
        type: _getTypeFromCategory(category),
        page: page,
        limit: _limit,
      ),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      final newItems = dataState.data!.data;
      final hasReachedMax = newItems.length < _limit;

      if (currentState is SavedItemsLoaded && !event.isRefresh) {
        emit(
          currentState.copyWith(
            items: List.of(currentState.items)..addAll(newItems),
            hasReachedMax: hasReachedMax,
            currentPage: page,
          ),
        );
      } else {
        emit(
          SavedItemsLoaded(
            items: newItems,
            currentCategory: category,
            hasReachedMax: hasReachedMax,
            currentPage: page,
          ),
        );
      }
    } else if (dataState is DataStateError) {
      emit(SavedItemsError(message: dataState.error.toString()));
    }
  }

  Future<void> _onChangeCategoryTab(
    ChangeCategoryTab event,
    Emitter<SavedItemsState> emit,
  ) async {
    final currentState = state;
    if (currentState is SavedItemsLoaded && currentState.currentCategory == event.category) {
      return;
    }

    emit(SavedItemsLoading());

    final dataState = await _getSavedItems(
      params: GetSavedItemsParams(
        type: _getTypeFromCategory(event.category),
        page: 1,
        limit: _limit,
      ),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(
        SavedItemsLoaded(
          items: dataState.data!.data,
          currentCategory: event.category,
          hasReachedMax: dataState.data!.data.length < _limit,
          currentPage: 1,
        ),
      );
    } else if (dataState is DataStateError) {
      emit(SavedItemsError(message: dataState.error.toString()));
    }
  }
}
