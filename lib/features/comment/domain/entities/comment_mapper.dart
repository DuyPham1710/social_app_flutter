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
      // Assuming your CommentEntity has a UserEntity field named 'user'
      user: user.toModel(), 
      postId: postId,
      // Map other fields. If fields are Entities, map them to Models.
      // parentId: parentId?.toModel(), 
      createdAt: createdAt,
      updatedAt: updatedAt,
      // reacts: reacts?.map((e) => e.toModel()).toList(),
    );
  }
}