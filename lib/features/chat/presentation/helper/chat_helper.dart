import 'package:flutter/material.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/group_avatar_widget.dart';

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

  static Widget buildAvatarWidget({
    required bool isGroup,
    String? groupAvatar,
    List<UserEntity>? participants,
    UserEntity? firstParticipant,
    double size = 36,
  }) {
    String displayAvatar;
    Widget avatarWidget;

    if (isGroup) {
      // Group chat
      displayAvatar = groupAvatar ?? 'https://i.pravatar.cc/200';

      // Nếu group có nhiều participants và không có avatar custom, dùng GroupAvatarWidget
      if (participants != null && participants.length > 1) {
        final avatarUrls = participants
            .where((p) => p.avatarUrl != null && p.avatarUrl!.isNotEmpty)
            .map((p) => p.avatarUrl!)
            .toList();

        avatarWidget = GroupAvatarWidget(
          avatarUrls: avatarUrls.isNotEmpty ? avatarUrls : [displayAvatar],
          totalParticipants: participants.length,
          size: size,
        );
      } else {
        avatarWidget = CircleAvatar(
          backgroundImage: NetworkImage(displayAvatar),
          radius: size / 2,
        );
      }
    } else {
      // 1-1 chat
      displayAvatar =
          firstParticipant?.avatarUrl ??
          "https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg";

      avatarWidget = CircleAvatar(
        backgroundImage: NetworkImage(displayAvatar),
        radius: size / 2,
      );
    }
    return avatarWidget;
  }
}
