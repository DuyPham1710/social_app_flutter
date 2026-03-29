import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/save/domain/entities/saved_entity.dart';

abstract class SavedItemsState extends Equatable {
  const SavedItemsState();

  @override
  List<Object?> get props => [];
}

class SavedItemsInitial extends SavedItemsState {}

class SavedItemsLoading extends SavedItemsState {}

class SavedItemsLoaded extends SavedItemsState {
  final List<SavedEntity> items;
  final String currentCategory;
  final bool hasReachedMax;
  final int currentPage;

  const SavedItemsLoaded({
    required this.items,
    required this.currentCategory,
    required this.hasReachedMax,
    required this.currentPage,
  });

  SavedItemsLoaded copyWith({
    List<SavedEntity>? items,
    String? currentCategory,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return SavedItemsLoaded(
      items: items ?? this.items,
      currentCategory: currentCategory ?? this.currentCategory,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [items, currentCategory, hasReachedMax, currentPage];
}

class SavedItemsError extends SavedItemsState {
  final String message;
  const SavedItemsError({required this.message});

  @override
  List<Object?> get props => [message];
}
