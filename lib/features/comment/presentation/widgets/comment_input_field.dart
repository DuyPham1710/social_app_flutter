import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class CommentInputField extends StatefulWidget {
  // ... (parameters remain the same)
  final Function(String content, List<String> taggedUserIds) onSendComment;
  final String? currentUserAvatar;
  final List<Map<String, dynamic>> suggestionList;
  final GlobalKey<FlutterMentionsState> mentionKey;
  final String? replyingToUserName;
  final VoidCallback? onCancelReply;

  const CommentInputField({
    super.key,
    required this.mentionKey,
    required this.onSendComment,
    required this.currentUserAvatar,
    required this.suggestionList,
    this.replyingToUserName,
    this.onCancelReply,
  });

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- 1. REPLY STATUS BAR ---
          if (widget.replyingToUserName != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              width: double.infinity,
              color: Colors.grey[100],
              child: Row(
                children: [
                  Text(
                    'Đang trả lời ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // --- SMART TEXT DISPLAY ---
                  Flexible(
                    child: Text(
                      widget.replyingToUserName == "ME"
                          ? "bình luận của bạn" // Custom text for self-reply
                          : widget.replyingToUserName!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const Spacer(),

                  // Cancel Button
                  GestureDetector(
                    onTap: () {
                      final controller =
                          widget.mentionKey.currentState?.controller;
                      controller?.clear();
                      widget.onCancelReply?.call();
                    },
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // --- 2. INPUT FIELD ---
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 8.h,
              left: 16.w,
              right: 10.w,
              top: 8.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: CircleAvatar(
                    radius: 18.r,
                    backgroundImage: NetworkImage(
                      widget.currentUserAvatar ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                Expanded(
                  child: FlutterMentions(
                    key: widget.mentionKey,
                    suggestionPosition: SuggestionPosition.Top,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      // Custom hint text based on reply state
                      hintText: widget.replyingToUserName != null
                          ? (widget.replyingToUserName == "ME"
                                ? 'Viết phản hồi...'
                                : 'Trả lời ${widget.replyingToUserName}...')
                          : 'Viết bình luận...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                    ),
                    mentions: [
                      Mention(
                        trigger: '@',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        data: widget.suggestionList,
                        matchAll: false,
                        markupBuilder: (trigger, value, display) {
                          return '@[$display]($value)';
                        },
                        suggestionBuilder: (data) {
                          return Container(
                            color: Colors.white,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Add slight delay to ensure proper tap detection
                                  Future.microtask(() {
                                    widget.mentionKey.currentState?.addMention(
                                      data,
                                    );
                                  });
                                },
                                splashColor: AppColors.primary.withOpacity(0.1),
                                highlightColor: AppColors.primary.withOpacity(
                                  0.05,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18.r,
                                        backgroundImage: NetworkImage(
                                          data['photo'] ??
                                              'https://via.placeholder.com/150',
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              data['display'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              '@${data['full_name']}',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey[600],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 6.w),

                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.paperplane_fill,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      final controller =
                          widget.mentionKey.currentState!.controller;

                      if (controller!.text.trim().isNotEmpty) {
                        final markupText = controller.markupText;
                        final RegExp regex = RegExp(
                          r"@\[([^\]]+)\]\(([^)]+)\)",
                        );
                        final matches = regex.allMatches(markupText);

                        List<String> taggedIds = [];
                        for (final match in matches) {
                          taggedIds.add(match.group(2)!);
                        }

                        widget.onSendComment(markupText, taggedIds);
                        controller.clear();

                        if (widget.replyingToUserName != null) {
                          widget.onCancelReply?.call();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
