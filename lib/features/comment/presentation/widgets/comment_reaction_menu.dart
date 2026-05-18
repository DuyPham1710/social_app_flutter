import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';
import 'dart:ui';

import 'package:social_app_fe/features/comment/presentation/widgets/mention_editable_field.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friends_usecase.dart';
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

                      SizedBox(height: 12.h),

                      // Hiển thị lại comment
                      _buildCommentBubble(comment),

                      SizedBox(height: 12.h),

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
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(40.r),
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
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(emoji.icon, style: TextStyle(fontSize: 28.sp)),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static Widget _buildCommentBubble(CommentEntity comment) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.r),
      ),
      constraints: BoxConstraints(maxWidth: 280.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.user.fullName ?? 'Unknown',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 3.h),

          ParsedText(
            text: comment.content,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
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
      width: 220.w,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          _menuItem(
            Icons.reply,
            'Trả lời',
            onTap: () {
              hide();
              if (onReply != null) {
                final userName =
                    comment.user.fullName ?? comment.user.username ?? 'Unknown';

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
                    null,
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
              'Chỉnh sửa',
              onTap: () async {
                hide(); // Ẩn menu reaction

                // 1. Load danh sách bạn bè
                final suggestionList = await _loadFriendSuggestions() ?? [];

                // 2. Tạo Key mới
                final mentionKey = GlobalKey<FlutterMentionsState>();

                // 3. Hiện Dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    // 🔥 QUAN TRỌNG: Bọc Portal ở đây để sửa lỗi màn hình đỏ
                    return Portal(
                      child: AlertDialog(
                        backgroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        title: Text(
                          'Chỉnh sửa bình luận',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        content: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            border: Border.all(
                              color: AppColors.divider,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.all(8.w),

                          // Gọi Widget Edit
                          child: MentionEditableField(
                            mentionKey: mentionKey,
                            suggestionList: suggestionList,
                            initialMarkup: comment.content,
                            hintText: 'Nhập nội dung mới...',
                          ),
                        ),

                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Hủy',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () {
                              final controller =
                                  mentionKey.currentState?.controller;
                              if (controller == null) return;

                              // Lấy markup text chuẩn
                              final newMarkup = controller.markupText.trim();

                              if (newMarkup.isNotEmpty &&
                                  newMarkup != comment.content) {
                                onUpdateComment?.call(comment.id, newMarkup);
                              }
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cập nhật',
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
              },
            ),
          // Chỉ hiển thị nút xóa nếu là comment của user hiện tại
          if (currentUserId != null && comment.user.userId == currentUserId)
            _menuItem(
              Icons.delete,
              'Xóa',
              color: Colors.red,
              onTap: () {
                hide();
                showCupertinoDialog(
                  context: context,
                  builder: (dialogContext) => CupertinoAlertDialog(
                    title: Text(
                      'Xóa bình luận',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    content: Text(
                      'Bạn có chắc chắn muốn xóa vĩnh viễn bình luận này không?',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // đóng dialog
                        },
                        child: const Text(
                          'Hủy',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          onDeleteComment?.call(comment.id, comment.postId);
                          Navigator.of(dialogContext).pop(); // đóng dialog
                        },
                        child: const Text(
                          'Xóa',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Chỉ hiển thị nút xem lịch sử nếu là comment của user hiện tại
          if (currentUserId != null && comment.user.userId == currentUserId)
            _menuItem(
              Icons.visibility,
              'Xem lịch sử chỉnh sửa',
              onTap: () {
                hide();
                onViewHistory?.call(comment.id, comment.content);
              },
            ),
          _menuItem(Icons.share, 'Chia sẻ bình luận'),
          _menuItem(
            Icons.copy,
            'Sao chép',
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
              showSuccessSnackBar(context, 'Đã sao chép nội dung');
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
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              Icon(icon, color: resolvedColor, size: 18.sp),
              SizedBox(width: 10.w),
              Text(
                text,
                style: TextStyle(color: resolvedColor, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
