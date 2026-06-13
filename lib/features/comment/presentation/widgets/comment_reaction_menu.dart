import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';
import 'dart:ui';

import 'package:social_app_fe/features/comment/presentation/widgets/mention_editable_field.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friends_usecase.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class CommentReactionMenu {
  static OverlayEntry? _overlayEntry;
  //nhận danh sách bạn bè để gợi ý mention
  static Future<List<Map<String, dynamic>>?> _loadFriendSuggestions() async {
    try {
      // 1. Lấy UseCase từ DI
      final getFriendsUseCase = s1<GetFriendsUseCase>();

      // 2. Gọi API lấy danh sách
      final dataState = await getFriendsUseCase();

      // 3. Kiểm tra kết quả
      if (dataState is DataStateSuccess && dataState.data != null) {
        final friends = dataState.data!;

        // 4. Map dữ liệu sang format yêu cầu: {id, display, full_name, photo}
        final mappedFriends = friends.map((friend) {
          return {
            'id': friend.userId,
            'display': friend.fullName ?? 'Unknown',
            'full_name': friend.fullName ?? 'Unknown',
            'photo':
                friend.avatarUrl ??
                'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          };
        }).toList();
        return mappedFriends;
      } else {
        // Xử lý lỗi nếu cần (DataFailed)
        print("Lỗi lấy danh sách bạn bè: ${dataState.error}");
      }
    } catch (e) {
      print("Exception khi load friend suggestions: $e");
    }
    return null;
  }

  static void show(
    BuildContext context,
    Offset position,
    CommentEntity comment, {
    Function(
      String userId,
      String userAvatar,
      String? parentId,
      String userDisplayName,
    )?
    onReply,
    Function(String commentId, EmojiType reaction)? onReactionChanged,
    String? currentUserId,
    Function(String commentId, String newContent)? onUpdateComment,
    Function(String commentId, String postId)? onDeleteComment,
    Function(String commentId, String currentContent)? onViewHistory,
  }) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            // Nền mờ
            GestureDetector(
              onTap: hide,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6.0, // độ nhòe ngang
                  sigmaY: 6.0, // độ nhòe dọc
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.2), // nền hơi tối nhẹ
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            // Menu
            Center(
              child: Material(
                color: Colors.transparent,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildReactBar(onReactionChanged, comment.id),

                      SizedBox(height: 12),

                      // Hiển thị lại comment
                      _buildCommentBubble(context, comment),

                      SizedBox(height: 12),

                      _buildActionMenu(
                        context,
                        comment,
                        onReply,
                        currentUserId,
                        onUpdateComment,
                        onDeleteComment,
                        onViewHistory,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static Widget _buildReactBar(
    Function(String commentId, EmojiType reaction)? onReactionChanged,
    String commentId,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: EmojiType.values
            .map(
              (emoji) => GestureDetector(
                onTap: () {
                  onReactionChanged?.call(commentId, emoji);
                  hide();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(emoji.icon, style: const TextStyle(fontSize: 28)),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static Widget _buildCommentBubble(
    BuildContext context,
    CommentEntity comment,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
      ),
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.user.fullName ?? context.l10n.commonUnknown,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.rsp(context),
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 3.rsh(context)),

          ParsedText(
            text: comment.content,
            style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            parse: [
              MatchText(
                pattern: r'@\[([^\]]+)\]\(([^)]+)\)',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                renderText: ({required String str, required String pattern}) {
                  final match = RegExp(pattern).firstMatch(str);
                  if (match == null) return {'display': str};

                  return {'display': match.group(2)!, 'value': match.group(1)!};
                },
                onTap: (userId) {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildActionMenu(
    BuildContext context,
    CommentEntity comment,
    Function(
      String userId,
      String userAvatar,
      String? parentId,
      String userDisplayName,
    )?
    onReply,
    String? currentUserId,
    Function(String commentId, String newContent)? onUpdateComment,
    Function(String commentId, String postId)? onDeleteComment,
    Function(String commentId, String currentContent)? onViewHistory,
  ) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _menuItem(
            Icons.reply,
            context.l10n.commentReply,
            onTap: () {
              hide();
              if (onReply != null) {
                final userName =
                    comment.user.fullName ??
                    comment.user.username ??
                    context.l10n.commonUnknown;

                if (comment.parentId != null) {
                  // Nếu đã là reply thì trả về parentId gốc
                  onReply(
                    comment.user.userId,
                    comment.user.avatarUrl ??
                        'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                    comment.parentId!.id,
                    userName,
                  );
                } else {
                  onReply(
                    comment.user.userId,
                    comment.user.avatarUrl ??
                        'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                    comment.id,
                    userName,
                  );
                }
              }
            },
          ),
          // Chỉ hiển thị nút chỉnh sửa nếu là comment của user hiện tại
          if (currentUserId != null && comment.user.userId == currentUserId)
            _menuItem(
              Icons.edit,
              context.l10n.commonEdit,
              onTap: () {
                hide(); // Ẩn menu reaction
                _handleEditAction(context, comment, onUpdateComment);
              },
            ),
          // Chỉ hiển thị nút xóa nếu là comment của user hiện tại
          if (currentUserId != null && comment.user.userId == currentUserId)
            _menuItem(
              Icons.delete,
              context.l10n.commonDelete,
              color: Colors.red,
              onTap: () {
                hide();
                _handleDeleteAction(context, comment, onDeleteComment);
              },
            ),

          // Chỉ hiển thị nút xem lịch sử nếu là comment của user hiện tại
          if (currentUserId != null && comment.user.userId == currentUserId)
            _menuItem(
              Icons.visibility,
              context.l10n.commentViewEditHistory,
              onTap: () {
                hide();
                onViewHistory?.call(comment.id, comment.content);
              },
            ),
          _menuItem(Icons.share, context.l10n.commentShare),
          _menuItem(
            Icons.copy,
            context.l10n.commonCopy,
            onTap: () {
              // 1. Dùng Regex để biến đổi @[Name](ID) thành @Name
              final String cleanText = comment.content.replaceAllMapped(
                RegExp(r'@\[([^\]]+)\]\(([^)]+)\)'),
                (match) =>
                    '${match.group(1)}', // Lấy dấu @ cộng với tên (group 1)
              );

              // 2. Sao chép text đã xử lý
              Clipboard.setData(ClipboardData(text: cleanText));

              hide();

              // (Tùy chọn) Hiển thị thông báo đã sao chép
              showSuccessSnackBar(context, context.l10n.commonContentCopied);
            },
          ),
        ],
      ),
    );
  }

  static Widget _menuItem(
    IconData icon,
    String text, {
    Color? color,
    VoidCallback? onTap,
  }) {
    final resolvedColor = color ?? AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: resolvedColor, size: 18),
              const SizedBox(width: 10),
              Text(text, style: TextStyle(color: resolvedColor, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  /// Hiển thị popup menu cho Web/Desktop khi bấm vào nút 3 chấm
  static void showWebPopupMenu(
    BuildContext context,
    RelativeRect position,
    CommentEntity comment, {
    Function(
      String userId,
      String userAvatar,
      String? parentId,
      String userDisplayName,
    )?
    onReply,
    Function(String commentId, EmojiType reaction)? onReactionChanged,
    String? currentUserId,
    Function(String commentId, String newContent)? onUpdateComment,
    Function(String commentId, String postId)? onDeleteComment,
    Function(String commentId, String currentContent)? onViewHistory,
  }) {
    final isOwner =
        currentUserId != null && comment.user.userId == currentUserId;
    final l10n = context.l10n;

    final List<PopupMenuEntry<String>> items = [
      PopupMenuItem<String>(
        value: 'reply',
        child: Row(
          children: [
            Icon(Icons.reply, color: AppColors.textPrimary, size: 18),
            const SizedBox(width: 10),
            Text(
              l10n.commentReply,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
          ],
        ),
      ),
      if (isOwner)
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: AppColors.textPrimary, size: 18),
              const SizedBox(width: 10),
              Text(
                l10n.commonEdit,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ],
          ),
        ),
      if (isOwner)
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 18),
              const SizedBox(width: 10),
              Text(
                l10n.commonDelete,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
      if (isOwner)
        PopupMenuItem<String>(
          value: 'history',
          child: Row(
            children: [
              Icon(Icons.visibility, color: AppColors.textPrimary, size: 18),
              const SizedBox(width: 10),
              Text(
                l10n.commentViewEditHistory,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ],
          ),
        ),
      PopupMenuItem<String>(
        value: 'copy',
        child: Row(
          children: [
            Icon(Icons.copy, color: AppColors.textPrimary, size: 18),
            const SizedBox(width: 10),
            Text(
              l10n.commonCopy,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
          ],
        ),
      ),
    ];

    showMenu<String>(
      context: context,
      position: position,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: items,
    ).then((value) {
      if (value == null) return;
      switch (value) {
        case 'reply':
          if (onReply != null) {
            final userName =
                comment.user.fullName ??
                comment.user.username ??
                l10n.commonUnknown;
            if (comment.parentId != null) {
              onReply(
                comment.user.userId,
                comment.user.avatarUrl ??
                    'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                comment.parentId!.id,
                userName,
              );
            } else {
              onReply(
                comment.user.userId,
                comment.user.avatarUrl ??
                    'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                comment.id,
                userName,
              );
            }
          }
        case 'edit':
          _handleEditAction(context, comment, onUpdateComment);
        case 'delete':
          _handleDeleteAction(context, comment, onDeleteComment);
        case 'history':
          onViewHistory?.call(comment.id, comment.content);
        case 'copy':
          final String cleanText = comment.content.replaceAllMapped(
            RegExp(r'@\[([^\]]+)\]\(([^)]+)\)'),
            (match) => '${match.group(1)}',
          );
          Clipboard.setData(ClipboardData(text: cleanText));
          showSuccessSnackBar(context, l10n.commonContentCopied);
      }
    });
  }

  /// Xử lý action Edit (dùng chung cho cả mobile overlay và web popup)
  static void _handleEditAction(
    BuildContext context,
    CommentEntity comment,
    Function(String commentId, String newContent)? onUpdateComment,
  ) async {
    final suggestionList = await _loadFriendSuggestions() ?? [];
    final mentionKey = GlobalKey<FlutterMentionsState>();

    showDialog(
      context: context,
      builder: (context) {
        return Portal(
          child: AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              context.l10n.commentEditTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            content: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: MentionEditableField(
                mentionKey: mentionKey,
                suggestionList: suggestionList,
                initialMarkup: comment.content,
                hintText: context.l10n.commentEditHint,
              ),
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  context.l10n.commonCancel,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final controller = mentionKey.currentState?.controller;
                  if (controller == null) return;
                  final newMarkup = controller.markupText.trim();
                  if (newMarkup.isNotEmpty && newMarkup != comment.content) {
                    onUpdateComment?.call(comment.id, newMarkup);
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  context.l10n.commonUpdate,
                  style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Xử lý action Delete (dùng chung cho cả mobile overlay và web popup)
  static void _handleDeleteAction(
    BuildContext context,
    CommentEntity comment,
    Function(String commentId, String postId)? onDeleteComment,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          context.l10n.commentDeleteTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          context.l10n.commentDeleteConfirm,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              context.l10n.commonCancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              onDeleteComment?.call(comment.id, comment.postId);
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              context.l10n.commonDelete,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
