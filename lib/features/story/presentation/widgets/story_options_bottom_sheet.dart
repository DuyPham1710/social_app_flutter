import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';
import 'package:social_app_fe/features/story/presentation/bloc/home_stories_bloc.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_privacy_settings_page.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_option_item_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

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
  final StoryRepository _storyRepository = s1<StoryRepository>();
  bool _isDeleting = false;

  Future<void> _deleteStory() async {
    final storyId = widget.currentGroup.stories[widget.currentStoryIndex].id;

    // Hiển thị dialog xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            context.l10n.storyDeleteTitle,
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Text(
            context.l10n.storyDeleteConfirm,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                context.l10n.commonCancel,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                context.l10n.commonDelete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final result = await _storyRepository.deleteStory(storyId: storyId);

      if (!mounted) return;

      final navigator = Navigator.of(context);
      final l10n = context.l10n;

      HomeStoriesBloc? homeStoriesBloc;
      try {
        homeStoriesBloc = context.read<HomeStoriesBloc>();
      } catch (_) {}

      if (result is DataStateSuccess) {
        navigator.pop(); // Đóng bottom sheet

        if (homeStoriesBloc != null) {
          homeStoriesBloc.add(const LoadHomeStoriesEvent(page: 1, limit: 10));
        }

        navigator.pop(); // Đóng story viewer

        if (navigator.mounted) {
          showSuccessSnackBar(navigator.context, l10n.storyDeleted);
        }
      } else if (result is DataStateError) {
        navigator.pop(); // Đóng bottom sheet
        if (navigator.mounted) {
          showErrorSnackBar(
            navigator.context,
            l10n.commonErrorWithMessage(
              result.error?.message ?? l10n.storyDeleteFailed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final navigator = Navigator.of(context);
        final l10n = context.l10n;
        navigator.pop(); // Đóng bottom sheet
        if (navigator.mounted) {
          showErrorSnackBar(
            navigator.context,
            l10n.commonErrorWithMessage('$e'),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
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
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement archive photo
              },
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
