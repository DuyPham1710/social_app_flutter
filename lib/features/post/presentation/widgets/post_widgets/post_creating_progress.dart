import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class PostCreatingProgress extends StatelessWidget {
  final double? progress; // 0.0 - 1.0 (tùy bạn có muốn tính % không)

  const PostCreatingProgress({super.key, this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        vertical: 8.rsh(context),
        horizontal: 16.rs(context),
      ),
      child: Row(
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          SizedBox(width: 12.rs(context)),
          Expanded(
            child: Text(
              progress != null
                  ? context.l10n.postCreatingWithProgress(
                      (progress! * 100).round(),
                    )
                  : context.l10n.postCreating,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.rsp(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
