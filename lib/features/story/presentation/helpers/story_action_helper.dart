import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';
import 'package:social_app_fe/features/story/presentation/bloc/home_stories_bloc.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class StoryActionHelper {
  static void _reloadHomeStories(BuildContext context) {
    try {
      final nav = Navigator.of(context, rootNavigator: false);
      final rootContext = nav.context;
      final homeStoriesBloc = rootContext.read<HomeStoriesBloc>();
      homeStoriesBloc.add(const LoadHomeStoriesEvent(page: 1, limit: 10));
    } catch (e) {
      try {
        final homeStoriesBloc = context.read<HomeStoriesBloc>();
        homeStoriesBloc.add(const LoadHomeStoriesEvent(page: 1, limit: 10));
      } catch (_) {}
    }
  }

  static Future<void> archiveStory({
    required BuildContext context,
    required String storyId,
    VoidCallback? onStart,
    VoidCallback? onComplete,
    required VoidCallback onSuccess,
    VoidCallback? onError,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.rsr(dialogContext)),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.symmetric(
              horizontal: 20.rs(dialogContext),
              vertical: 24.rsh(dialogContext),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.rsr(dialogContext)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.archive_outlined,
                    size: 32.rsp(dialogContext),
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 16.rsh(dialogContext)),
                Text(
                  context.l10n.storyArchiveTitle,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18.rsp(dialogContext),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.rsh(dialogContext)),
                Text(
                  context.l10n.storyArchiveConfirm,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.rsp(dialogContext),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.rsh(dialogContext)),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.rsh(dialogContext),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.rsr(dialogContext),
                            ),
                            side: BorderSide(color: AppColors.divider),
                          ),
                          backgroundColor: AppColors.secondBackground,
                        ),
                        child: Text(
                          context.l10n.commonCancel,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.rsp(dialogContext),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.rs(dialogContext)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.rsh(dialogContext),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.rsr(dialogContext),
                            ),
                          ),
                        ),
                        child: Text(
                          context.l10n.commonConfirm,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.rsp(dialogContext),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    onStart?.call();

    try {
      final storyRepository = s1<StoryRepository>();
      final result = await storyRepository.archiveStory(storyId: storyId);

      if (!context.mounted) return;

      final navigator = Navigator.of(context);
      final l10n = context.l10n;

      if (result is DataStateSuccess) {
        _reloadHomeStories(context);
        onSuccess();

        if (navigator.mounted) {
          showSuccessSnackBar(navigator.context, l10n.storyArchived);
        }
      } else if (result is DataStateError) {
        onError?.call();
        if (navigator.mounted) {
          showErrorSnackBar(
            navigator.context,
            l10n.commonErrorWithMessage(
              result.error?.message ?? l10n.storyArchiveFailed,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        final navigator = Navigator.of(context);
        final l10n = context.l10n;
        onError?.call();
        if (navigator.mounted) {
          showErrorSnackBar(
            navigator.context,
            l10n.commonErrorWithMessage('$e'),
          );
        }
      }
    } finally {
      onComplete?.call();
    }
  }

  static Future<void> deleteStory({
    required BuildContext context,
    required String storyId,
    VoidCallback? onStart,
    VoidCallback? onComplete,
    required VoidCallback onSuccess,
    VoidCallback? onError,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            context.l10n.storyDeleteTitle,
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Text(
              context.l10n.storyDeleteConfirm,
              style: TextStyle(color: AppColors.textSecondary),
            ),
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

    onStart?.call();

    try {
      final storyRepository = s1<StoryRepository>();
      final result = await storyRepository.deleteStory(storyId: storyId);

      if (!context.mounted) return;

      final navigator = Navigator.of(context);
      final l10n = context.l10n;

      if (result is DataStateSuccess) {
        _reloadHomeStories(context);
        onSuccess();

        if (navigator.mounted) {
          showSuccessSnackBar(navigator.context, l10n.storyDeleted);
        }
      } else if (result is DataStateError) {
        onError?.call();
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
      if (context.mounted) {
        final navigator = Navigator.of(context);
        final l10n = context.l10n;
        onError?.call();
        if (navigator.mounted) {
          showErrorSnackBar(
            navigator.context,
            l10n.commonErrorWithMessage('$e'),
          );
        }
      }
    } finally {
      onComplete?.call();
    }
  }
}
