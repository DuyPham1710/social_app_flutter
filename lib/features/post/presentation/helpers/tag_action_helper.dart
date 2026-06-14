import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/update_tag_visibility_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/remove_tag_usecase.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class TagActionHelper {
  static Future<void> handleTagVisibility({
    required BuildContext context,
    required String postId,
    required bool isVisible,
    required Function() onSuccess,
  }) async {
    final l10n = context.l10n;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          isVisible
              ? l10n.postShowOnProfileTitle
              : l10n.postHideFromProfileTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.rsp(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isVisible
              ? l10n.postShowOnProfileMessage
              : l10n.postHideFromProfileMessage,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.rsp(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.commonCancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              isVisible ? l10n.postShowAction : l10n.postHideAction,
              style: TextStyle(
                color: isVisible ? AppColors.primary : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await s1<UpdateTagVisibilityUsecase>()(
      params: UpdateTagVisibilityParams(postId: postId, isVisible: isVisible),
    );

    if (result is DataStateSuccess) {
      onSuccess();
      if (context.mounted) {
        showSuccessSnackBar(
          context,
          isVisible ? l10n.postShownOnProfile : l10n.postHiddenFromProfile,
        );
      }
    } else {
      if (context.mounted) {
        showErrorSnackBar(context, l10n.postGenericError);
      }
    }
  }

  static Future<void> handleRemoveTag({
    required BuildContext context,
    required String postId,
    required Function() onSuccess,
  }) async {
    final l10n = context.l10n;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          l10n.postRemoveTagTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.rsp(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          l10n.postRemoveTagConfirmMessage,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.rsp(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.commonCancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.postRemoveTagAction,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await s1<RemoveTagUsecase>()(params: postId);

    if (result is DataStateSuccess) {
      onSuccess();
      if (context.mounted) {
        showSuccessSnackBar(context, l10n.postRemovedTag);
      }
    } else {
      if (context.mounted) {
        showErrorSnackBar(context, l10n.postGenericError);
      }
    }
  }
}
