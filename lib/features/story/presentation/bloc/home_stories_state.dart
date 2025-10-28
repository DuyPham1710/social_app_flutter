part of 'home_stories_bloc.dart';

abstract class HomeStoriesState extends Equatable {
  const HomeStoriesState();
  @override
  List<Object?> get props => [];
}

class HomeStoriesInitial extends HomeStoriesState {}

class HomeStoriesLoading extends HomeStoriesState {}

class HomeStoriesLoaded extends HomeStoriesState {
  final GroupedStoryListEntity groupedStories;
  const HomeStoriesLoaded(this.groupedStories);
  @override
  List<Object?> get props => [groupedStories];
}

class HomeStoriesError extends HomeStoriesState {
  final String message;
  const HomeStoriesError(this.message);
  @override
  List<Object?> get props => [message];
}
