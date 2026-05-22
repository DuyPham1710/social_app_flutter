import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/story/domain/entities/react_story_entity.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class StoryReactListWidget extends StatelessWidget {
  final List<ReactStoryEntity> reacts;

  const StoryReactListWidget({super.key, required this.reacts});

  @override
  Widget build(BuildContext context) {
    if (reacts.isEmpty) {
      return Center(
        child: Text(
          context.l10n.storyNoReactions,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: reacts.length,
      itemBuilder: (context, index) {
        final react = reacts[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 20.r,
            backgroundImage: react.user.avatarUrl != null
                ? NetworkImage(react.user.avatarUrl!)
                : null,
            child: react.user.avatarUrl == null
                ? Icon(Icons.person, color: AppColors.textSecondary)
                : null,
          ),
          title: Text(
            react.user.fullName ??
                react.user.username ??
                context.l10n.commonUser,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            react.user.username ?? '',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
          trailing: Text(react.emoji.icon, style: TextStyle(fontSize: 24.sp)),
        );
      },
    );
  }
}
