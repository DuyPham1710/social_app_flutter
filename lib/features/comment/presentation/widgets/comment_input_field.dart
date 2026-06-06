import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

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
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- 1. REPLY STATUS BAR ---
          if (widget.replyingToUserName != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.rs(context), vertical: 8.rsh(context)),
              width: double.infinity,
              color: AppColors.secondBackground,
              child: Row(
                children: [
                  Text(
                    context.l10n.commentReplyingPrefix,
                    style: TextStyle(
                      fontSize: 12.rsp(context),
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // --- SMART TEXT DISPLAY ---
                  Flexible(
                    child: Text(
                      widget.replyingToUserName == "ME"
                          ? context.l10n.commentYourComment
                          : widget.replyingToUserName!,
                      style: TextStyle(
                        fontSize: 12.rsp(context),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
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
                      context.l10n.commonCancel,
                      style: TextStyle(
                        fontSize: 12.rsp(context),
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
              bottom: MediaQuery.of(context).viewInsets.bottom + 8.rsh(context),
              left: 16.rs(context),
              right: 10.rs(context),
              top: 8.rsh(context),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.rsh(context)),
                  child: CircleAvatar(
                    radius: 18.rsr(context),
                    backgroundImage: NetworkImage(
                      widget.currentUserAvatar ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
                    ),
                  ),
                ),
                SizedBox(width: 10.rs(context)),

                Expanded(
                  child: FlutterMentions(
                    key: widget.mentionKey,
                    suggestionPosition: SuggestionPosition.Top,
                    maxLines: 5,
                    minLines: 1,
                    style: TextStyle(
                      fontSize: 14.rsp(context),
                      color: AppColors.textPrimary,
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      // Custom hint text based on reply state
                      hintText: widget.replyingToUserName != null
                          ? (widget.replyingToUserName == "ME"
                                ? context.l10n.commentWriteReplyHint
                                : context.l10n.commentReplyToHint(
                                    widget.replyingToUserName!,
                                  ))
                          : context.l10n.commentWriteHint,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.rsp(context),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.rs(context),
                        vertical: 8.rsh(context),
                      ),
                    ),
                    mentions: [
                      Mention(
                        trigger: '@',
                        style: TextStyle(
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
                            color: AppColors.background,
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
                                    horizontal: 16.rs(context),
                                    vertical: 12.rsh(context),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.divider,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18.rsr(context),
                                        backgroundImage: NetworkImage(
                                          data['photo'] ??
                                              'https://via.placeholder.com/150',
                                        ),
                                      ),
                                      SizedBox(width: 12.rs(context)),
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
                                                fontSize: 14.rsp(context),
                                                color: AppColors.textPrimary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 2.rsh(context)),
                                            Text(
                                              '@${data['full_name']}',
                                              style: TextStyle(
                                                fontSize: 12.rsp(context),
                                                color: AppColors.textSecondary,
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

                SizedBox(width: 6.rs(context)),

                Padding(
                  padding: EdgeInsets.only(bottom: 4.rsh(context)),
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.paperplane_fill,
                      color: AppColors.primary,
                      size: 24.rsp(context),
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
