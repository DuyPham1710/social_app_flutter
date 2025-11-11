import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/post/domain/entities/create_post_entity.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class CreatePostRequested extends PostEvent {
  final CreatePostEntity postEntity;

  const CreatePostRequested({required this.postEntity});

  @override
  List<Object?> get props => [postEntity];
}
