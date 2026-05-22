import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/story/domain/entities/create_story_entity.dart';

abstract class StoryCreateEvent extends Equatable {
  const StoryCreateEvent();

  @override
  List<Object?> get props => [];
}

class CreateStoryRequested extends StoryCreateEvent {
  final CreateStoryEntity story;

  const CreateStoryRequested({required this.story});

  @override
  List<Object?> get props => [story];
}
