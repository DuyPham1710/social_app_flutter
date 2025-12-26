import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';

class ChatHelper {
  static String formatConversationName(
    ConversationEntity conversation,
    List<UserEntity> otherParticipants,
    UserEntity? firstParticipant,
  ) {
    String displayName;
    if (conversation.isGroup) {
      if (conversation.name != null && conversation.name!.isNotEmpty) {
        // Group có tên
        displayName = conversation.name!;
      } else {
        // Group không có tên -> lấy tên 3 user cuối
        final namesToShow = otherParticipants.take(3).map((p) {
          return p.fullName?.trim().split(' ').last ?? p.username ?? 'User';
        }).toList();

        if (namesToShow.length > 1) {
          displayName = namesToShow.join(', ');
        } else {
          displayName = 'Group Chat';
        }
      }
    } else {
      // 1-1 chat
      displayName =
          firstParticipant?.fullName ?? firstParticipant?.username ?? "Unknown";
    }
    return displayName;
  }
}
