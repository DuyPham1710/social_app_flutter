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
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class StoryWebOptionsPopup extends StatelessWidget {
  final GroupedUserStoryEntity currentGroup;
  final int currentStoryIndex;
  final String? currentUserId;

  const StoryWebOptionsPopup({
    super.key,
    required this.currentGroup,
    required this.currentStoryIndex,
    this.currentUserId,
  });

  void _onSelected(BuildContext context, String value) {
    final storyId = currentGroup.stories[currentStoryIndex].id;
    if (value == 'edit_privacy') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StoryPrivacySettingsPage(storyId: storyId),
        ),
      );
    } else if (value == 'archive') {
      // TODO: Implement archive photo
    } else if (value == 'delete') {
      _deleteStoryWeb(context, storyId);
    }
  }

  Future<void> _deleteStoryWeb(BuildContext context, String storyId) async {
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
    if (!context.mounted) return;

    try {
      final storyRepository = s1<StoryRepository>();
      final result = await storyRepository.deleteStory(storyId: storyId);

      if (!context.mounted) return;

      final navigator = Navigator.of(context);
      final l10n = context.l10n;

      HomeStoriesBloc? homeStoriesBloc;
      try {
        homeStoriesBloc = context.read<HomeStoriesBloc>();
      } catch (_) {}

      if (result is DataStateSuccess) {
        if (homeStoriesBloc != null) {
          homeStoriesBloc.add(const LoadHomeStoriesEvent(page: 1, limit: 10));
        }
        navigator.pop(); // Pop story viewer

        if (navigator.mounted) {
          showSuccessSnackBar(navigator.context, l10n.storyDeleted);
        }
      } else if (result is DataStateError) {
        showErrorSnackBar(
          context,
          l10n.commonErrorWithMessage(
            result.error?.message ?? l10n.storyDeleteFailed,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, context.l10n.commonErrorWithMessage('$e'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => _onSelected(context, value),
      offset: Offset(-30.rs(context), 40.rsh(context)),
      color: AppColors.secondBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.rsr(context)),
      ),
      icon: Container(
        padding: EdgeInsets.all(6.rs(context)),
        decoration: const BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.more_vert,
          color: Colors.white,
          size: 20.rsp(context),
        ),
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'edit_privacy',
          child: Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: AppColors.iconPrimary,
                size: 20.rsp(context),
              ),
              SizedBox(width: 8.rs(context)),
              Text(
                context.l10n.storyEditPrivacy,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.rsp(context),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'archive',
          child: Row(
            children: [
              Icon(
                Icons.archive_outlined,
                color: AppColors.iconPrimary,
                size: 20.rsp(context),
              ),
              SizedBox(width: 8.rs(context)),
              Text(
                context.l10n.storyArchivePhoto,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.rsp(context),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              SizedBox(width: 8.rs(context)),
              Text(
                context.l10n.storyDeletePhoto,
                style: TextStyle(color: Colors.red, fontSize: 14.rsp(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
