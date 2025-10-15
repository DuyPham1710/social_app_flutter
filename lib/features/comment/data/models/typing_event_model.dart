import 'package:social_app_fe/features/comment/domain/entities/typing_entity.dart';

/// Model for typing events from WebSocket
class TypingEventModel extends TypingEntity {
  const TypingEventModel({
    required super.userId,
    required super.username,
    required super.isTyping,
    required super.postId,
  });

  /// Factory constructor để parse từ JSON response
  factory TypingEventModel.fromJson(Map<String, dynamic> json) {
    return TypingEventModel(
      userId: json['userId'] as String,
      username: json['username'] as String?,
      isTyping: json['isTyping'] as bool,
      postId: json['postId'] as String,
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'isTyping': isTyping,
      'postId': postId,
    };
  }
}

