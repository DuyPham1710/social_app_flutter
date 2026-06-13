import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_privacy_settings_page.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_option_item_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/features/story/presentation/helpers/story_action_helper.dart';

class StoryOptionsBottomSheet extends StatefulWidget {
  final GroupedUserStoryEntity currentGroup;
  final int currentStoryIndex;

  const StoryOptionsBottomSheet({
    super.key,
    required this.currentGroup,
    required this.currentStoryIndex,
  });

  @override
  State<StoryOptionsBottomSheet> createState() =>
      _StoryOptionsBottomSheetState();

  static void show(
    BuildContext context, {
    required GroupedUserStoryEntity currentGroup,
    required int currentStoryIndex,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StoryOptionsBottomSheet(
          currentGroup: currentGroup,
          currentStoryIndex: currentStoryIndex,
        );
      },
    );
  }
}

class _StoryOptionsBottomSheetState extends State<StoryOptionsBottomSheet> {
  bool _isDeleting = false;
  bool _isArchiving = false;

  Future<void> _archiveStory(BuildContext context) async {
    final storyId = widget.currentGroup.stories[widget.currentStoryIndex].id;

    await StoryActionHelper.archiveStory(
      context: context,
      storyId: storyId,
      onStart: () {
        setState(() {
          _isArchiving = true;
        });
      },
      onComplete: () {
        if (mounted) {
          setState(() {
            _isArchiving = false;
          });
        }
      },
      onSuccess: () {
        Navigator.pop(context); // Đóng bottom sheet
        Navigator.of(context).pop(); // Đóng story viewer
      },
      onError: () {
        Navigator.pop(context); // Đóng bottom sheet
      },
    );
  }

  Future<void> _deleteStory() async {
    final storyId = widget.currentGroup.stories[widget.currentStoryIndex].id;

    await StoryActionHelper.deleteStory(
      context: context,
      storyId: storyId,
      onStart: () {
        setState(() {
          _isDeleting = true;
        });
      },
      onComplete: () {
        if (mounted) {
          setState(() {
            _isDeleting = false;
          });
        }
      },
      onSuccess: () {
        Navigator.pop(context); // Đóng bottom sheet
        Navigator.of(context).pop(); // Đóng story viewer
      },
      onError: () {
        Navigator.pop(context); // Đóng bottom sheet
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.rsr(context)),
          topRight: Radius.circular(20.rsr(context)),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.rsh(context)),
            Container(
              width: 40.rs(context),
              height: 4.rsh(context),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.rsr(context)),
              ),
            ),
            SizedBox(height: 20.rsh(context)),
            StoryOptionItemWidget(
              icon: Icons.lock_outline,
              title: context.l10n.storyEditPrivacy,
              onTap: () {
                Navigator.pop(context);
                final storyId =
                    widget.currentGroup.stories[widget.currentStoryIndex].id;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StoryPrivacySettingsPage(storyId: storyId),
                  ),
                );
              },
            ),
            StoryOptionItemWidget(
              icon: Icons.archive_outlined,
              title: context.l10n.storyArchivePhoto,
              subtitle: context.l10n.storyArchivePhotoDescription,
              onTap: _isArchiving ? null : () => _archiveStory(context),
            ),
            StoryOptionItemWidget(
              icon: Icons.delete_outline,
              title: context.l10n.storyDeletePhoto,
              onTap: _isDeleting ? null : _deleteStory,
            ),
            SizedBox(height: 20.rsh(context)),
          ],
        ),
      ),
    );
  }
}
