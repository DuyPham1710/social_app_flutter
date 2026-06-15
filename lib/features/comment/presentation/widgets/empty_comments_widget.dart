import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class EmptyCommentsWidget extends StatelessWidget {
  final VoidCallback? onTapToComment;

  const EmptyCommentsWidget({super.key, this.onTapToComment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.rs(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64.rs(context),
            color: AppColors.unselectedIcon,
          ),

          SizedBox(height: 16.rsh(context)),

          Text(
            context.l10n.commentEmptyTitle,
            style: TextStyle(
              fontSize: 18.rsp(context),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.rsh(context)),

          Text(
            context.l10n.commentEmptySubtitle,
            style: TextStyle(fontSize: 14.rsp(context), color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),

          if (onTapToComment != null) ...[
            SizedBox(height: 24.rsh(context)),

            ElevatedButton.icon(
              onPressed: onTapToComment,
              icon: Icon(Icons.edit_outlined, size: 18.rs(context), color: Colors.white),
              label: Text(
                context.l10n.commentWriteFirst,
                style: TextStyle(fontSize: 14.rsp(context), color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: EdgeInsets.symmetric(horizontal: 24.rs(context), vertical: 12.rsh(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.rsr(context)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
