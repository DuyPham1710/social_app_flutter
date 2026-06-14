import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/attachment_type.dart';
import 'package:social_app_fe/core/utils/date_time_extensions.dart';
import 'package:social_app_fe/core/utils/video_util.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/message_hover_wrapper.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/reaction_detail_dialog.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/call_message_item.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/audio_message_bubble.dart';
import 'package:social_app_fe/features/post/presentation/pages/video_player_screen.dart';
import 'package:social_app_fe/shared/helpers/full_screen_image_viewer.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_info_snackBar.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_app_fe/features/chat/presentation/pages/pdf_viewer_page.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

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
  final VoidCallback? onReplyAction;
  final VoidCallback? onReactAction;

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
    this.onReplyAction,
    this.onReactAction,
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

  Future<void> _downloadAndOpenFile(
    BuildContext context,
    String url,
    String fileName,
  ) async {
    try {
      showInfoSnackBar(context, context.l10n.chatDownloadingFile);

      final tempDir = await getTemporaryDirectory();
      // Ensure fileName is safe
      final safeFileName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
      final savePath = '${tempDir.path}/$safeFileName';

      final file = File(savePath);
      if (!await file.exists()) {
        final dio = Dio();
        await dio.download(url, savePath);
      }

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done && context.mounted) {
        showErrorSnackBar(context, context.l10n.chatNoAppToOpenFile);
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          context.l10n.chatOpenFileFailed(e.toString()),
        );
      }
    }
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
    final isStoryReply = message.story != null;
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
    final isLocationMessage = message.metadata?.type == 'location';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show unread indicator if this is the first unread message
        if (isFirstUnreadMessage && unreadCount != null && unreadCount! > 0)
          _buildUnreadIndicator(context),

        // Show "Đã chỉnh sửa" nếu tin nhắn đã được chỉnh sửa
        if (isEdited) _buildEditedText(context),

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

              if (ResponsiveHelper.isWebOrDesktop)
                Expanded(
                  child: _buildMessageWrapper(
                    isDeleteforEveryone,
                    context,
                    lastName,
                    isReplying,
                    isStoryReply,
                    isLocationMessage,
                    isHasMetaData,
                    isAudioAttachment,
                    hasReactions,
                  ),
                )
              else
                Flexible(
                  child: _buildMessageWrapper(
                    isDeleteforEveryone,
                    context,
                    lastName,
                    isReplying,
                    isStoryReply,
                    isLocationMessage,
                    isHasMetaData,
                    isAudioAttachment,
                    hasReactions,
                  ),
                ),
            ],
          ),
        ),

        hasReactions ? SizedBox(height: 20.h) : SizedBox.shrink(),

        // Hiển thị trạng thái tin nhắn
        _buildMessageStatus(context),

        if (showAvatar) SizedBox(height: 16.h),
      ],
    );
  }

  MessageHoverWrapper _buildMessageWrapper(
    bool isDeleteforEveryone,
    BuildContext context,
    String lastName,
    bool isReplying,
    bool isStoryReply,
    bool isLocationMessage,
    bool isHasMetaData,
    bool isAudioAttachment,
    bool hasReactions,
  ) {
    return MessageHoverWrapper(
      fromMe: fromMe,
      isDeleted: isDeleteforEveryone,
      onReact: onReactAction ?? onDoubleTap,
      onReply: onReplyAction,
      onMore: onLongPress,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,

          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.loose,
            children: [
              isDeleteforEveryone
                  ? _buildDeletedMessage(context, lastName, fromMe)
                  : isReplying
                  ? _buildReplyMessage(context)
                  : isStoryReply
                  ? _buildStoryReplyMessage(context)
                  : isLocationMessage
                  ? _buildLocationMessage(context)
                  : isHasMetaData
                  ? VideoCallMessageItem(
                      fromMe: fromMe,
                      callType: message.metadata!.type == 'video_call'
                          ? 'video'
                          : 'audio',
                      callStatus: message.metadata!.callStatus ?? 'completed',
                      duration: message.metadata!.duration,
                      timestamp: message.createdAt,
                      onCallAgain: onCallAgain,
                    )
                  :
                    // Kiểm tra xem có phải là emoji không
                    message.text != null && _isOnlyEmoji(message.text!)
                  ? _buildEmojiMessage()
                  : isAudioAttachment
                  ? AudioMessageBubble(
                      fromMe: fromMe,
                      attachment: message.attachments.first,
                    )
                  : _buildMessageContent(context),

              // Show reactions if any
              if (hasReactions) _buildReactionBubble(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeletedMessage(
    BuildContext context,
    String lastName,
    bool fromMe,
  ) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: (ResponsiveHelper.isWebOrDesktop ? 400.0 : 0.7.sw),
      ),
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
        fromMe
            ? context.l10n.chatYouDeletedMessage
            : context.l10n.chatUserDeletedMessage(lastName),
        style: TextStyle(
          fontSize: 14.sp,
          fontStyle: FontStyle.italic,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildUnreadIndicator(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              context.l10n.chatUnreadMessages(unreadCount!),
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

  Widget _buildEditedText(BuildContext context) {
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
              context.l10n.chatEdited,
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

  Widget _buildMessageStatus(BuildContext context) {
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
              context.l10n.chatSentAt(message.createdAt.formatRelativeTime()),
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
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.text != null && message.text!.isNotEmpty)
            SelectionArea(
              child: Text(
                message.text!,
                style: TextStyle(
                  fontSize: 26.sp, // Cỡ chữ lớn hơn cho emoji
                ),
              ),
            ),

          // Show attachments if any
          // if (message.attachments.isNotEmpty)
          //   _buildAttachmentsGrid(context, message.attachments),
        ],
      ),
    );
  }

  Widget _buildReplyMessage(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: (ResponsiveHelper.isWebOrDesktop ? 400.0 : 0.7.sw),
      ),
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
                      ? _buildReplyAttachmentPreview(
                          message.replyTo!.attachments.first,
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
                            context.l10n.commonUnknown,
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
                            ? _getAttachmentTypeString(
                                context,
                                message.replyTo!.attachments.first.type,
                              )
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
                  MouseRegion(
                    cursor: SystemMouseCursors.text,
                    child: SelectionArea(
                      child: Text(
                        message.text!,
                        style: TextStyle(
                          color: fromMe ? Colors.white : AppColors.textPrimary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),

                // Show file attachments if any
                if (message.attachments.any((att) => att.type == 'file'))
                  _buildFileList(
                    context,
                    message.attachments
                        .where((att) => att.type == 'file')
                        .toList(),
                  ),
                // Show media attachments if any
                if (message.attachments.any(
                  (att) => att.type == 'image' || att.type == 'video',
                ))
                  _buildAttachmentsGrid(context, message.attachments),
              ],
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildStoryReplyMessage(BuildContext context) {
    final story = message.story!;
    return Container(
      constraints: BoxConstraints(
        maxWidth: (ResponsiveHelper.isWebOrDesktop ? 400.0 : 0.7.sw),
      ),
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
          // Story Reply header card
          Container(
            margin: EdgeInsets.all(8.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: fromMe
                  ? AppColors.background
                  : AppColors.textSecondary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10.r),
              border: Border(
                left: BorderSide(
                  color: fromMe ? Colors.white70 : AppColors.primary,
                  width: 3.w,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Story thumbnail preview
                if (story.mediaUrl != null && story.mediaUrl!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: Container(
                      width: 40.w,
                      height: 55.w,
                      color: AppColors.iconPrimary,
                      child: Image.network(
                        story.mediaUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          size: 20.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ],
            ),
          ),

          // Replied Text message
          if (message.text != null && message.text!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 8.h),
              child: MouseRegion(
                cursor: SystemMouseCursors.text,
                child: SelectionArea(
                  child: Text(
                    message.text!,
                    style: TextStyle(
                      color: fromMe
                          ? AppColors.background
                          : AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            )
          else
            SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildNormalMessage() {
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: Container(
        // Giới hạn chiều rộng tối đa của tin nhắn (khoảng 70% màn hình)
        constraints: BoxConstraints(
          maxWidth: (ResponsiveHelper.isWebOrDesktop ? 400.0 : 0.7.sw),
        ),
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
        child: SelectionArea(
          child: Text(
            message.text!,
            style: TextStyle(
              color: fromMe ? Colors.white : AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    final hasText = message.text != null && message.text!.isNotEmpty;
    final fileAttachments = message.attachments
        .where((att) => att.type == 'file')
        .toList();
    final mediaAttachments = message.attachments
        .where((att) => att.type == 'image' || att.type == 'video')
        .toList();

    return Column(
      crossAxisAlignment: fromMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasText) _buildNormalMessage(),
        if (hasText &&
            (fileAttachments.isNotEmpty || mediaAttachments.isNotEmpty))
          SizedBox(height: 4.h),
        if (fileAttachments.isNotEmpty)
          _buildFileList(context, fileAttachments),
        if (fileAttachments.isNotEmpty && mediaAttachments.isNotEmpty)
          SizedBox(height: 4.h),
        if (mediaAttachments.isNotEmpty)
          _buildAttachmentsGrid(context, mediaAttachments),
      ],
    );
  }

  Widget _buildFileList(
    BuildContext context,
    List<AttachmentEntity> fileAttachments,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: fromMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: fileAttachments.map((file) {
        return GestureDetector(
          onTap: () async {
            String downloadUrl = file.url;
            if (downloadUrl.startsWith('/')) {
              final baseUrl =
                  dotenv.env['BASE_URL'] ?? 'http://192.168.100.218:3000/';
              final baseUrlWithoutTrailingSlash = baseUrl.endsWith('/')
                  ? baseUrl.substring(0, baseUrl.length - 1)
                  : baseUrl;
              downloadUrl = '$baseUrlWithoutTrailingSlash$downloadUrl';
            }

            final fileName = file.name?.toLowerCase() ?? '';
            if (fileName.endsWith('.pdf')) {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                    url: downloadUrl,
                    fileName: file.name ?? 'Document.pdf',
                  ),
                ),
              );
            } else {
              await _downloadAndOpenFile(
                context,
                downloadUrl,
                file.name ?? 'downloaded_file',
              );
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 4.h),
            constraints: BoxConstraints(
              maxWidth: (ResponsiveHelper.isWebOrDesktop ? 400.0 : 0.7.sw),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: fromMe
                  ? AppColors.primary
                  : AppColors.textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: fromMe
                    ? Colors.transparent
                    : AppColors.textSecondary.withOpacity(0.15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: fromMe
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.insert_drive_file,
                    color: fromMe ? Colors.white : AppColors.primary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name ?? 'Document',
                        style: TextStyle(
                          color: fromMe ? Colors.white : AppColors.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatFileSize(file.size),
                        style: TextStyle(
                          color: fromMe
                              ? Colors.white.withOpacity(0.8)
                              : AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Widget _buildLocationMessage(BuildContext context) {
    final label = message.metadata?.label ?? context.l10n.messageLocation;
    final lat = message.metadata?.latitude;
    final lng = message.metadata?.longitude;
    final mapUrl = message.metadata?.mapUrl;

    final subText = (lat != null && lng != null)
        ? '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}'
        : (mapUrl ?? '');

    return InkWell(
      onTap: mapUrl == null
          ? null
          : () async {
              final uri = Uri.tryParse(mapUrl);
              if (uri == null) return;
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(14.r),
        topRight: Radius.circular(14.r),
        bottomLeft: Radius.circular(fromMe ? 14.r : 0),
        bottomRight: Radius.circular(fromMe ? 0 : 14.r),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: (ResponsiveHelper.isWebOrDesktop ? 400.0 : 0.7.sw),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
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
          border: Border.all(
            color: fromMe
                ? Colors.transparent
                : AppColors.textSecondary.withOpacity(0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: fromMe ? Colors.white : AppColors.primary,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: fromMe ? Colors.white : AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subText.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: fromMe
                            ? Colors.white.withOpacity(0.9)
                            : AppColors.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Icon(
              Icons.open_in_new,
              color: fromMe ? Colors.white : AppColors.textSecondary,
              size: 18.sp,
            ),
          ],
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
    final maxWidth = (ResponsiveHelper.isWebOrDesktop ? 400.0 : 0.7.sw);
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
                    ? buildVideoThumbnail(attachment.url)
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

  Widget _buildReplyAttachmentPreview(AttachmentEntity attachment) {
    final type = attachment.type;
    if (type == AttachmentType.image.name) {
      return Image.network(
        attachment.url,
        width: 40.w,
        height: 40.w,
        fit: BoxFit.cover,
      );
    } else if (type == AttachmentType.video.name) {
      return SizedBox(
        width: 40.w,
        height: 40.w,
        child: buildVideoThumbnail(attachment.url, height: 40.w),
      );
    } else if (type == AttachmentType.file.name) {
      return Container(
        width: 40.w,
        height: 40.w,
        color: AppColors.textSecondary.withOpacity(0.1),
        child: Icon(
          Icons.insert_drive_file,
          size: 20.sp,
          color: AppColors.primary,
        ),
      );
    }
    return SizedBox.shrink();
  }

  String _getAttachmentTypeString(BuildContext context, String type) {
    if (type == AttachmentType.audio.name) return context.l10n.chatAudioMessage;
    if (type == AttachmentType.image.name) return context.l10n.chatPhoto;
    if (type == AttachmentType.video.name) return context.l10n.postVideo;
    if (type == AttachmentType.file.name) return context.l10n.chatFile;
    return context.l10n.chatAttachment;
  }
}
