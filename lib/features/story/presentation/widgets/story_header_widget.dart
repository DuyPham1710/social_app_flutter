import 'package:flutter/material.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_progress_bar_widget.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_user_info_widget.dart';

class StoryHeaderWidget extends StatelessWidget {
  final AnimationController animationController;
  final GroupedUserStoryEntity currentGroup;
  final int currentStoryIndex;
  final VoidCallback onClose;
  final String? currentUserId;

  const StoryHeaderWidget({
    super.key,
    required this.animationController,
    required this.currentGroup,
    required this.currentStoryIndex,
    required this.onClose,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thanh tiến trình
        StoryProgressBarWidget(
          animationController: animationController,
          totalStories: currentGroup.stories.length,
          currentStoryIndex: currentStoryIndex,
        ),

        // Thông tin người dùng
        StoryUserInfoWidget(
          currentGroup: currentGroup,
          currentStoryIndex: currentStoryIndex,
          currentUserId: currentUserId,
          onClose: onClose,
        ),
      ],
    );
  }
}
