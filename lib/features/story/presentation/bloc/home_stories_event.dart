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

class ReactStoryEvent extends HomeStoriesEvent {
  final String storyId;
  final String emojiId;
  const ReactStoryEvent({required this.storyId, required this.emojiId});
  @override
  List<Object?> get props => [storyId, emojiId];
}

class GetStoryReactsEvent extends HomeStoriesEvent {
  final String storyId;
  const GetStoryReactsEvent({required this.storyId});
  @override
  List<Object?> get props => [storyId];
}

class CheckUserReactStoryEvent extends HomeStoriesEvent {
  final String storyId;
  const CheckUserReactStoryEvent({required this.storyId});
  @override
  List<Object?> get props => [storyId];
}

class UpdateReactStoryEvent extends HomeStoriesEvent {
  final String storyId;
  final String emojiId;
  const UpdateReactStoryEvent({required this.storyId, required this.emojiId});
  @override
  List<Object?> get props => [storyId, emojiId];
}

class DeleteReactStoryEvent extends HomeStoriesEvent {
  final String storyId;
  const DeleteReactStoryEvent({required this.storyId});
  @override
  List<Object?> get props => [storyId];
}
