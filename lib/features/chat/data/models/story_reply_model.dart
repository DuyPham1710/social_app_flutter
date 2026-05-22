import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import '../../domain/entities/story_reply_entity.dart';

class StoryReplyModel {
  final String id;
  final String? title;
  final String? mediaUrl;
  final String? mediaType;
  final UserModel user;
  final DateTime createdAt;

  StoryReplyModel({
    required this.id,
    this.title,
    this.mediaUrl,
    this.mediaType,
    required this.user,
    required this.createdAt,
  });

  factory StoryReplyModel.fromJson(Map<String, dynamic> json) {
    return StoryReplyModel(
      id: (json['_id'] ?? json['id']) as String,
      title: json['title'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String?,
      user: UserModel.fromJson(json['userId'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'mediaUrl': mediaUrl,
    'mediaType': mediaType,
    'userId': user.toJson(),
    'createdAt': createdAt.toIso8601String(),
  };

  StoryReplyEntity toEntity() => StoryReplyEntity(
    id: id,
    title: title,
    mediaUrl: mediaUrl,
    mediaType: mediaType,
    user: user.toEntity(),
    createdAt: createdAt,
  );
}
