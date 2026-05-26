import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommentContentBubble extends StatelessWidget {
  final UserEntity user;
  final String content;
  final VoidCallback onTapProfile;
  final Function(String userId) onMentionTap;

  const CommentContentBubble({
    super.key,
    required this.user,
    required this.content,
    required this.onTapProfile,
    required this.onMentionTap,
  });

  /// Regex chuẩn cho mention
  static final RegExp _mentionRegex = RegExp(r'@\[([^\]]+)\]\(([^)]+)\)');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundCommentItem,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== USER NAME =====
          GestureDetector(
            onTap: onTapProfile,
            child: Text(
              user.fullName ?? context.l10n.commonUnknown,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          /// ===== COMMENT CONTENT =====
          ParsedText(
            text: content,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
            parse: [
              MatchText(
                pattern: _mentionRegex.pattern,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),

                renderText: ({required String str, required String pattern}) {
                  final match = _mentionRegex.firstMatch(str);
                  if (match == null) return {'display': str};

                  final displayName = match.group(1)!;

                  return {'display': displayName};
                },

                onTap: (matchedText) {
                  final match = _mentionRegex.firstMatch(matchedText);
                  if (match == null) return;

                  final userId = match.group(2)!;
                  onMentionTap(userId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
