import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/save/domain/usecases/get_saved_items_usecase.dart';
import 'package:social_app_fe/features/save/domain/usecases/unsave_post_usecase.dart';
import 'saved_items_event.dart';
import 'saved_items_state.dart';

class SavedItemsBloc extends Bloc<SavedItemsEvent, SavedItemsState> {
  final GetSavedItemsUsecase _getSavedItems;
  final UnsavePostUsecase _unsavePost;

  static const int _limit = 20;
  static const List<String> _baseCategories = [
    'Tất cả',
    'Bài viết',
    'Thước phim',
    'Bình luận',
  ];
  static const String _collectionPrefix = 'BST: ';

  SavedItemsBloc(this._getSavedItems, this._unsavePost)
    : super(SavedItemsInitial()) {
    on<LoadSavedItems>(_onLoadSavedItems);
    on<ChangeCategoryTab>(_onChangeCategoryTab);
    on<RemoveSavedItem>(_onRemoveSavedItem);
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
        return null;
    }
  }

  String? _getCollectionFromCategory(String category) {
    if (!category.startsWith(_collectionPrefix)) return null;
    final collection = category.substring(_collectionPrefix.length).trim();
    return collection.isEmpty ? null : collection;
  }

  Future<List<String>> _loadCategories() async {
    final dataState = await _getSavedItems(
      params: GetSavedItemsParams(page: 1, limit: 100),
    );

    if (dataState is! DataStateSuccess || dataState.data == null) {
      return _baseCategories;
    }

    final collections = dataState.data!.data
        .map((item) => item.collection.trim())
        .where((collection) => collection.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return [
      ..._baseCategories,
      ...collections.map((collection) => '$_collectionPrefix$collection'),
    ];
  }

  Future<void> _onLoadSavedItems(
    LoadSavedItems event,
    Emitter<SavedItemsState> emit,
  ) async {
    final currentState = state;
    String category = 'Tất cả';
    List<String> categories = _baseCategories;
    int page = 1;

    if (currentState is SavedItemsLoaded) {
      categories = currentState.categories;
      if (event.isRefresh) {
        category = currentState.currentCategory;
        categories = await _loadCategories();
        // Keep loading visual trick if needed by emitting loading
        // emit(SavedItemsLoading());
      } else {
        if (currentState.hasReachedMax) return;
        category = currentState.currentCategory;
        page = currentState.currentPage + 1;
      }
    } else {
      emit(SavedItemsLoading());
      categories = await _loadCategories();
    }

    final dataState = await _getSavedItems(
      params: GetSavedItemsParams(
        type: _getTypeFromCategory(category),
        collection: _getCollectionFromCategory(category),
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
            categories: categories,
            hasReachedMax: hasReachedMax,
            currentPage: page,
          ),
        );
      } else {
        emit(
          SavedItemsLoaded(
            items: newItems,
            currentCategory: category,
            categories: categories,
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
    if (currentState is SavedItemsLoaded &&
        currentState.currentCategory == event.category) {
      return;
    }

    emit(SavedItemsLoading());
    final categories = currentState is SavedItemsLoaded
        ? currentState.categories
        : await _loadCategories();

    final dataState = await _getSavedItems(
      params: GetSavedItemsParams(
        type: _getTypeFromCategory(event.category),
        collection: _getCollectionFromCategory(event.category),
        page: 1,
        limit: _limit,
      ),
    );

    if (dataState is DataStateSuccess && dataState.data != null) {
      emit(
        SavedItemsLoaded(
          items: dataState.data!.data,
          currentCategory: event.category,
          categories: categories,
          hasReachedMax: dataState.data!.data.length < _limit,
          currentPage: 1,
        ),
      );
    } else if (dataState is DataStateError) {
      emit(SavedItemsError(message: dataState.error.toString()));
    }
  }

  Future<void> _onRemoveSavedItem(
    RemoveSavedItem event,
    Emitter<SavedItemsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SavedItemsLoaded) return;

    final dataState = await _unsavePost(
      params: UnsavePostParams(savedId: event.savedId),
    );

    if (dataState is DataStateSuccess) {
      emit(
        currentState.copyWith(
          items: currentState.items
              .where((item) => item.id != event.savedId)
              .toList(),
        ),
      );
      emit(const SavedItemsActionSuccess('Đã xóa khỏi danh sách đã lưu'));
      emit(
        currentState.copyWith(
          items: currentState.items
              .where((item) => item.id != event.savedId)
              .toList(),
        ),
      );
    } else if (dataState is DataStateError) {
      emit(SavedItemsError(message: dataState.error.toString()));
      emit(currentState);
    }
  }
}
