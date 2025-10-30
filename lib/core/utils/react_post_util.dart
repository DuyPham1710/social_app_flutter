import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/core/enums/emoji.dart';

List<ReactPostEntity> updateLocalReacts({
  required List<ReactPostEntity> currentReacts,
  required String? currentUserId,
  required EmojiType? newReaction,
  required PostEntity post,
  Map<String, dynamic>? userData,
}) {
  final updatedReacts = List<ReactPostEntity>.from(currentReacts);
  final index = updatedReacts.indexWhere(
    (react) => react.user.userId == currentUserId,
  );

  if (newReaction != null) {
    // Nếu đã tồn tại reaction -> cập nhật emoji
    if (index != -1) {
      final oldReact = updatedReacts[index];
      updatedReacts[index] = ReactPostEntity(
        id: oldReact.id,
        user: oldReact.user,
        postId: oldReact.postId,
        emoji: newReaction,
        createdAt: oldReact.createdAt,
        updatedAt: DateTime.now(),
      );
    } else {
      // Nếu chưa có -> thêm mới
      final user = UserEntity(
        userId: currentUserId!,
        username: userData?['username'],
        fullName: userData?['fullName'],
        avatarUrl: userData?['avatarUrl'],
      );

      updatedReacts.add(
        ReactPostEntity(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          user: user,
          postId: post.id,
          emoji: newReaction,
          createdAt: DateTime.now(),
        ),
      );
    }
  } else {
    // Nếu unreact -> xóa khỏi list
    if (index != -1) {
      updatedReacts.removeAt(index);
    }
  }

  return updatedReacts;
}
