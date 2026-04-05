import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/attachment_type.dart';
import 'package:social_app_fe/core/utils/date_time_extensions.dart';
import 'package:social_app_fe/core/utils/video_util.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/reaction_detail_dialog.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/call_message_item.dart';
import 'package:social_app_fe/features/post/presentation/pages/video_player_screen.dart';
import 'package:social_app_fe/shared/helpers/full_screen_image_viewer.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';

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
  final VoidCallback? onCallAgain;
  final bool isFirstUnreadMessage;
  final int? unreadCount;

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
    this.onCallAgain,
    this.isFirstUnreadMessage = false,
    this.unreadCount,
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

  void _showVideoPlayer(BuildContext context, String videoUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoData: videoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = message.replyTo != null;
    final hasReactions = message.reactions.isNotEmpty;
    final isEdited = message.isEdited;
    final isDeleteforEveryone = message.deletedForEveryone;
    final lastName = message.sender.fullName!.trim().split(' ').last;
    final isAttachment = message.attachments.isNotEmpty;
    final isAudioAttachment =
        isAttachment &&
        message.attachments.first.type == AttachmentType.audio.name;
    final isHasMetaData =
        message.metadata != null &&
        (message.metadata!.type == 'video_call' ||
            message.metadata!.type == 'audio_call');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show unread indicator if this is the first unread message
        if (isFirstUnreadMessage && unreadCount != null && unreadCount! > 0)
          _buildUnreadIndicator(),

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
                      message.sender.avatarUrl ??
                          "https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg",
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
                          ? _buildReplyMessage(context)
                          : isHasMetaData
                          ? VideoCallMessageItem(
                              fromMe: fromMe,
                              callType: message.metadata!.type == 'video_call'
                                  ? 'video'
                                  : 'audio',
                              callStatus:
                                  message.metadata!.callStatus ?? 'completed',
                              duration: message.metadata!.duration,
                              timestamp: message.createdAt,
                              onCallAgain: onCallAgain,
                            )
                          :
                            // Kiểm tra xem có phải là emoji không
                            message.text != null && _isOnlyEmoji(message.text!)
                          ? _buildEmojiMessage()
                          : isAudioAttachment
                          ? _buildAudioMessage(
                              context,
                              message.attachments.first,
                            )
                          : isAttachment
                          ? _buildAttachmentsGrid(context, message.attachments)
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

        if (showAvatar) SizedBox(height: 16.h),
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

  Widget _buildUnreadIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              '$unreadCount tin nhắn chưa đọc',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
        ],
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
          if (isSeenByOthers) ...[
            // Hiển thị +n nếu có nhiều hơn 10 người
            if (seenByUsers.length > 10)
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  '+${seenByUsers.length - 10}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            // Hiển thị tối đa 10 avatars
            ...seenByUsers.take(10).map((user) {
              return Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: CircleAvatar(
                  radius: 8.r,
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : const NetworkImage("https://i.pravatar.cc/200"),
                ),
              );
            }),
          ] else
            // Hiển thị text "Đã gửi"
            Text(
              'Đã gửi ${message.createdAt.formatRelativeTime()}',
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
        // if (message.attachments.isNotEmpty)
        //   _buildAttachmentsGrid(context, message.attachments),
      ],
    );
  }

  Widget _buildReplyMessage(BuildContext context) {
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  message.replyTo!.attachments.isNotEmpty
                      ? Image.network(
                          message.replyTo!.attachments.first.url,
                          width: 40.w,
                          height: 40.w,
                          fit: BoxFit.cover,
                        )
                      : SizedBox.shrink(),

                  message.replyTo!.attachments.isNotEmpty
                      ? SizedBox(width: 8.w)
                      : SizedBox.shrink(),

                  Column(
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
                        message.replyTo!.attachments.isNotEmpty
                            ? '[${message.replyTo!.attachments.first.type}]'
                            : message.replyTo!.text,
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
                  _buildAttachmentsGrid(context, message.attachments),
              ],
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildAudioMessage(BuildContext context, AttachmentEntity attachment) {
    return Container(
      constraints: BoxConstraints(maxWidth: 0.7.sw),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: fromMe
            ? AppColors.primary
            : AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: Radius.circular(fromMe ? 16.r : 0),
          bottomRight: Radius.circular(fromMe ? 0 : 16.r),
        ),
      ),
      
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.play_arrow_rounded,
            color: fromMe ? Colors.white : AppColors.textPrimary,
            size: 32.sp,
          ),
          SizedBox(width: 8.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(15, (index) {
              final heights = [
                8.0,
                14.0,
                20.0,
                10.0,
                24.0,
                12.0,
                18.0,
                8.0,
                22.0,
                14.0,
                10.0,
                16.0,
                8.0,
                18.0,
                12.0,
              ];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                width: 3.w,
                height: heights[index].h,
                decoration: BoxDecoration(
                  color: fromMe ? Colors.white : AppColors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              );
            }),
          ),
          SizedBox(width: 12.w),
          Text(
            "0:02",
            style: TextStyle(
              color: fromMe ? Colors.white : AppColors.textPrimary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
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
      child: Text(
        message.text!,
        style: TextStyle(
          color: fromMe ? Colors.white : AppColors.textPrimary,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  // Build grid of image attachments (max 3 per row)
  Widget _buildAttachmentsGrid(
    BuildContext context,
    List<AttachmentEntity> attachments,
  ) {
    // Filter only image attachments
    final imageAttachments = attachments
        .where(
          (att) =>
              att.type == AttachmentType.image.name ||
              att.type == AttachmentType.video.name,
        )
        .toList();

    // Get image URLs
    final imageUrls = imageAttachments.map((att) => att.url).toList();

    // Calculate grid layout
    final imageCount = imageAttachments.length;
    final maxWidth = 0.7.sw;
    final spacing = 4.w;
    final itemSize = (maxWidth - (spacing * 2)) / 3; // 3 items per row

    return Container(
      margin: EdgeInsets.only(top: 4.h),
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(imageCount, (index) {
          final attachment = imageAttachments[index];

          // Calculate width for last row items if not full
          final rowIndex = index ~/ 3;
          final isLastRow = rowIndex == ((imageCount - 1) ~/ 3);

          double itemWidth = itemSize;
          if (isLastRow && imageCount % 3 != 0) {
            // Last row with less than 3 items
            final itemsInLastRow = imageCount % 3;
            itemWidth =
                (maxWidth - (spacing * (itemsInLastRow - 1))) / itemsInLastRow;
          }

          return GestureDetector(
            onTap: () {
              // Check if video
              if (VideoUtil.isVideo(attachment.url)) {
                _showVideoPlayer(context, attachment.url);
              } else {
                // image viewer
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImageViewer(
                      imageUrls: imageUrls,
                      initialIndex: index,
                    ),
                  ),
                );
              }
            },

            child: Container(
              width: itemWidth,
              height: itemWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.textSecondary.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: VideoUtil.isVideo(attachment.url)
                    ? buildVideoThumbnail()
                    : Image.network(
                        attachment.url,
                        fit: BoxFit.cover,

                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.textSecondary.withOpacity(0.1),
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.textSecondary.withOpacity(0.1),
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.textSecondary,
                              size: 24.sp,
                            ),
                          );
                        },
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
