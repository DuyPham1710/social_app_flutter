import 'package:equatable/equatable.dart';

abstract class SavedItemsEvent extends Equatable {
  const SavedItemsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedItems extends SavedItemsEvent {
  final bool isRefresh;
  const LoadSavedItems({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class ChangeCategoryTab extends SavedItemsEvent {
  final String category; // 'Tất cả', 'Thước phim', 'Bài viết'...
  const ChangeCategoryTab(this.category);

  @override
  List<Object?> get props => [category];
}
