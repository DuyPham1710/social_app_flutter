import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryHeaderWidget extends StatelessWidget {
  final AnimationController animationController;
  final GroupedUserStoryEntity currentGroup;
  final int currentStoryIndex;
  final VoidCallback onClose;

  const StoryHeaderWidget({
    super.key,
    required this.animationController,
    required this.currentGroup,
    required this.currentStoryIndex,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thanh tiến trình
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            children: List.generate(currentGroup.stories.length, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      double value;
                      if (i < currentStoryIndex) {
                        value = 1.0;
                      } else if (i == currentStoryIndex) {
                        value = animationController.value;
                      } else {
                        value = 0.0;
                      }
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                        minHeight: 4.h,
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ),

        // Thông tin người dùng
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: NetworkImage(
                  currentGroup.user.avatarUrl ?? '',
                ),
              ),

              SizedBox(width: 8.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentGroup.user.fullName ?? 'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      currentGroup.stories[currentStoryIndex].createdAt != null
                          ? timeago.format(
                              currentGroup
                                  .stories[currentStoryIndex]
                                  .createdAt!,
                            )
                          : "Unknown date",
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
