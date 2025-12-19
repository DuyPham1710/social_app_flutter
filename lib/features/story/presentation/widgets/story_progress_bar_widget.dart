import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class StoryProgressBarWidget extends StatelessWidget {
  final AnimationController animationController;
  final int totalStories;
  final int currentStoryIndex;

  const StoryProgressBarWidget({
    super.key,
    required this.animationController,
    required this.totalStories,
    required this.currentStoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: List.generate(totalStories, (i) {
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
    );
  }
}

