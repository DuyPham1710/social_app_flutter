import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class StoryReplyEntity extends Equatable {
  final String id;
  final String? title;
  final String? mediaUrl;
  final String? mediaType;
  final UserEntity user;
  final DateTime createdAt;

  const StoryReplyEntity({
    required this.id,
    this.title,
    this.mediaUrl,
    this.mediaType,
    required this.user,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, mediaUrl, mediaType, user, createdAt];
}
