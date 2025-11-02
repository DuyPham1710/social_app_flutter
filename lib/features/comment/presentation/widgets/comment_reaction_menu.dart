import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';
import 'dart:ui';

import 'package:social_app_fe/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_event.dart';

class CommentReactionMenu {
  static OverlayEntry? _overlayEntry;

  static void show(
    BuildContext context,
    Offset position,
    CommentEntity comment, {
    Function(String userDisplayName)? onReply,
    Function(String commentId, EmojiType reaction)? onReactionChanged,
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
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReactBar(onReactionChanged, comment.id),

                    SizedBox(height: 12.h),

                    // Hiển thị lại comment
                    _buildCommentBubble(comment),

                    SizedBox(height: 12.h),

                    _buildActionMenu(context, comment, onReply),
                  ],
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

          Text(
            comment.content,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  static Widget _buildActionMenu(
    BuildContext context,
    CommentEntity comment,
    Function(String userDisplayName)? onReply,
  ) {
    return Container(
      width: 200.w,
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
                onReply(userName);
              }
            },
          ),
          _menuItem(Icons.edit, 'Chỉnh sửa'),
          _menuItem(
            Icons.delete,
            'Xóa',
            color: Colors.red,
            onTap: () {
              hide();
              showCupertinoDialog(
                context: context,
                builder: (dialogContext) => CupertinoAlertDialog(
                  title: const Text(
                    'Xóa bình luận',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  content: const Text(
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
                        context.read<CommentBloc>().add(
                          DeleteCommentEvent(
                            commentId: comment.id,
                            postId: comment.postId,
                          ),
                        );

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
          _menuItem(Icons.share, 'Chia sẻ bình luận'),
          _menuItem(
            Icons.copy,
            'Sao chép',
            onTap: () {
              Clipboard.setData(ClipboardData(text: comment.content));
              hide();
            },
          ),
        ],
      ),
    );
  }

  static Widget _menuItem(
    IconData icon,
    String text, {
    Color color = AppColors.textPrimary,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18.sp),
              SizedBox(width: 10.w),
              Text(
                text,
                style: TextStyle(color: color, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
