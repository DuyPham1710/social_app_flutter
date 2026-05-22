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

class ReactStorySuccess extends HomeStoriesState {
  final String storyId;
  const ReactStorySuccess(this.storyId);
  @override
  List<Object?> get props => [storyId];
}

class StoryReactsLoaded extends HomeStoriesState {
  final String storyId;
  final List<dynamic> reacts;
  const StoryReactsLoaded({required this.storyId, required this.reacts});
  @override
  List<Object?> get props => [storyId, reacts];
}

class UserReactStoryChecked extends HomeStoriesState {
  final String storyId;
  final Map<String, dynamic>? userReact;
  const UserReactStoryChecked({required this.storyId, this.userReact});
  @override
  List<Object?> get props => [storyId, userReact];
}
