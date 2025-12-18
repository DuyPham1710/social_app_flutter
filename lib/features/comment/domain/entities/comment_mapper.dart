// features/comment/data/mappers/comment_mapper.dart
import 'package:social_app_fe/features/auth/domain/entities/user_mapper.dart';
import 'package:social_app_fe/features/comment/data/models/comment_model.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';
// Import other mappers if needed (React, Parent)

extension CommentEntityX on CommentEntity {
  CommentModel toModel() {
    return CommentModel(
      id: id,
      content: content,
      user: user.toModel(), 
      postId: postId,
      taggedUsers: taggedUsers?.map((e) => e.toModel()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}