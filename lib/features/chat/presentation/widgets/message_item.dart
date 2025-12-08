import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/reaction_detail_dialog.dart';

class MessageItem extends StatelessWidget {
  final MessageEntity message;
  final bool fromMe;
  final bool showAvatar;
  final Function(String messageId)? onReplyTap;
  final bool isLastMessage;
  final String currentUserId;
  final List<UserEntity> otherParticipants;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onEditHistoryTap;

  const MessageItem({
    super.key,
    required this.message,
    required this.fromMe,
    required this.showAvatar,
    this.onReplyTap,
    this.isLastMessage = false,
    required this.currentUserId,
    this.otherParticipants = const [],
    this.onLongPress,
    this.onDoubleTap,
    this.onEditHistoryTap,
  });

  // Kiểm tra xem tin nhắn đã được xem bởi người khác chưa (không tính mình)
  // bool _isSeenByOthers() {
  //   return message.seenBy.any((seenBy) => seenBy.user.userId != currentUserId);
  // }

  // Lấy danh sách người đã xem (không tính mình)
  List<UserEntity> _getSeenByUsers() {
    return message.seenBy
        .where((seenBy) => seenBy.user.userId != currentUserId)
        .map((seenBy) => seenBy.user)
        .toList();
  }

  // Kiểm tra xem text có phải là emoji không
  bool _isOnlyEmoji(String text) {
    if (text.trim().isEmpty) return false;

    // Loại bỏ khoảng trắng
    final trimmedText = text.trim();

    // Kiểm tra xem có phải là emoji không (Unicode emoji range)
    final emojiRegex = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );

    // Kiểm tra xem tất cả kí tự có phải là emoji không
    final matches = emojiRegex.allMatches(trimmedText);
    final emojiLength = matches.fold<int>(
      0,
      (sum, match) => sum + match.group(0)!.length,
    );

    // Nếu toàn bộ text là emoji và không quá 5 emoji
    return emojiLength == trimmedText.length && matches.length <= 5;
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = message.replyTo != null;
    final hasReactions = message.reactions.isNotEmpty;
    final isEdited = message.isEdited;
    final isDeleteforEveryone = message.deletedForEveryone;
    final lastName = message.sender.fullName!.trim().split(' ').last;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show "Đã chỉnh sửa" nếu tin nhắn đã được chỉnh sửa
        if (isEdited) _buildEditedText(),

        Container(
          margin: EdgeInsets.only(
            bottom: 4.h,
            left: fromMe ? 60.w : 0,
            right: fromMe ? 0 : 60.w,
          ),
          child: Row(
            mainAxisAlignment: fromMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!fromMe) ...[
                if (showAvatar)
                  CircleAvatar(
                    radius: 14.r,
                    backgroundImage: NetworkImage(
                      message.sender.avatarUrl ?? "https://i.pravatar.cc/200",
                    ),
                  )
                else
                  SizedBox(width: 28.r),

                SizedBox(width: 8.w),
              ],

              Flexible(
                child: GestureDetector(
                  onLongPress: onLongPress,
                  onDoubleTap: onDoubleTap,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.loose,
                    children: [
                      isDeleteforEveryone
                          ? _buildDeletedMessage(lastName, fromMe)
                          : isReplying
                          ? _buildReplyMessage()
                          :
                            // Kiểm tra xem có phải là emoji không
                            message.text != null && _isOnlyEmoji(message.text!)
                          ? _buildEmojiMessage()
                          : _buildNormalMessage(),

                      // Show reactions if any
                      if (hasReactions) _buildReactionBubble(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        hasReactions ? SizedBox(height: 20.h) : SizedBox.shrink(),

        // Hiển thị trạng thái tin nhắn
        _buildMessageStatus(),
      ],
    );
  }

  Widget _buildDeletedMessage(String lastName, bool fromMe) {
    return Container(
      constraints: BoxConstraints(maxWidth: 0.7.sw),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.4)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.r),
          topRight: Radius.circular(14.r),
          bottomLeft: Radius.circular(fromMe ? 14.r : 0),
          bottomRight: Radius.circular(fromMe ? 0 : 14.r),
        ),
      ),
      child: Text(
        fromMe ? 'Bạn đã xóa tin nhắn này' : '$lastName đã xóa tin nhắn này',
        style: TextStyle(
          fontSize: 14.sp,
          fontStyle: FontStyle.italic,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildEditedText() {
    return GestureDetector(
      onTap: onEditHistoryTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: 2.h,
          left: fromMe ? 0 : 40.w,
          right: fromMe ? 10.w : 0,
        ),
        child: Row(
          mainAxisAlignment: fromMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              'Đã chỉnh sửa',
              style: TextStyle(
                fontSize: 11.sp,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildReactionBubble(BuildContext context) {
    return Positioned(
      bottom: -16.h,
      right: fromMe ? 0 : -4.w,

      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ReactionDetailDialog(reactions: message.reactions);
            },
          );
        },

        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.secondBackground,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: message.reactions.map((reaction) {
              return Text(
                reaction.emoji.icon,
                style: TextStyle(fontSize: 12.sp),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageStatus() {
    if (!fromMe || !isLastMessage) return const SizedBox.shrink();

    final seenByUsers = _getSeenByUsers();
    final isSeenByOthers = seenByUsers.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(top: 4.h, right: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isSeenByOthers)
            ...
            // Hiển thị avatar của người đã xem
            seenByUsers.take(3).map((user) {
              return Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: CircleAvatar(
                  radius: 8.r,
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : const NetworkImage("https://i.pravatar.cc/200"),
                ),
              );
            })
          else
            // Hiển thị text "Đã gửi"
            Text(
              'Đã gửi',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmojiMessage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.text != null && message.text!.isNotEmpty)
          Text(
            message.text!,
            style: TextStyle(
              fontSize: 26.sp, // Cỡ chữ lớn hơn cho emoji
            ),
          ),

        // Show attachments if any
        if (message.attachments.isNotEmpty)
          ...message.attachments.map(
            (attachment) => Container(
              margin: EdgeInsets.only(top: 4.h),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: fromMe
                    ? AppColors.primary
                    : AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                '[${attachment.type.toUpperCase()}] ${attachment.url}',
                style: TextStyle(
                  color: fromMe ? Colors.white70 : AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReplyMessage() {
    return Container(
      constraints: BoxConstraints(maxWidth: 0.7.sw),
      decoration: BoxDecoration(
        color: fromMe
            ? AppColors.primary
            : AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.r),
          topRight: Radius.circular(14.r),
          bottomLeft: Radius.circular(fromMe ? 14.r : 0),
          bottomRight: Radius.circular(fromMe ? 0 : 14.r),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Replied message container
          GestureDetector(
            onTap: () {
              onReplyTap!(message.replyTo!.id);
            },

            child: Container(
              margin: EdgeInsets.all(8.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: fromMe
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border(
                  left: BorderSide(
                    color: fromMe ? Colors.white : AppColors.primary,
                    width: 3.w,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Replied name
                  Text(
                    message.replyTo!.sender.fullName ??
                        message.replyTo!.sender.username ??
                        'Unknown',
                    style: TextStyle(
                      color: fromMe ? Colors.white : AppColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Replied message text
                  Text(
                    message.replyTo!.text,
                    style: TextStyle(
                      color: fromMe
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Current message content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                if (message.text != null && message.text!.isNotEmpty)
                  Text(
                    message.text!,
                    style: TextStyle(
                      color: fromMe ? Colors.white : AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),

                // Show attachments if any
                if (message.attachments.isNotEmpty)
                  ...message.attachments.map(
                    (attachment) => Container(
                      margin: EdgeInsets.only(top: 4.h),
                      child: Text(
                        '[${attachment.type.toUpperCase()}] ${attachment.url}',
                        style: TextStyle(
                          color: fromMe
                              ? Colors.white70
                              : AppColors.textSecondary,
                          fontSize: 12.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildNormalMessage() {
    return Container(
      // Giới hạn chiều rộng tối đa của tin nhắn (khoảng 70% màn hình)
      constraints: BoxConstraints(maxWidth: 0.7.sw),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: fromMe
            ? AppColors.primary
            : AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.r),
          topRight: Radius.circular(14.r),
          bottomLeft: Radius.circular(fromMe ? 14.r : 0),
          bottomRight: Radius.circular(fromMe ? 0 : 14.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.text != null && message.text!.isNotEmpty)
            Text(
              message.text!,
              style: TextStyle(
                color: fromMe ? Colors.white : AppColors.textPrimary,
                fontSize: 14.sp,
              ),
            ),

          // Show attachments if any
          if (message.attachments.isNotEmpty)
            ...message.attachments.map(
              (attachment) => Container(
                margin: EdgeInsets.only(top: 4.h),
                child: Text(
                  '[${attachment.type.toUpperCase()}] ${attachment.url}',
                  style: TextStyle(
                    color: fromMe ? Colors.white70 : AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
