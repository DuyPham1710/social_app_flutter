part of 'home_stories_bloc.dart';

abstract class HomeStoriesEvent extends Equatable {
  const HomeStoriesEvent();
  @override
  List<Object?> get props => [];
}

class LoadHomeStoriesEvent extends HomeStoriesEvent {
  final int page;
  final int limit;
  const LoadHomeStoriesEvent({this.page = 1, this.limit = 10});
  @override
  List<Object?> get props => [page, limit];
}
