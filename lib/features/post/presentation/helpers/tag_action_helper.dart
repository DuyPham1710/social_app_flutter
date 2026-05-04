import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/usecases/update_tag_visibility_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/remove_tag_usecase.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class TagActionHelper {
  static Future<void> handleTagVisibility({
    required BuildContext context,
    required String postId,
    required bool isVisible,
    required Function() onSuccess,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          isVisible ? 'Hiển thị trên trang cá nhân' : 'Ẩn khỏi trang cá nhân',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          isVisible
              ? 'Bài viết này sẽ xuất hiện trên trang cá nhân của bạn và mọi người có thể nhìn thấy nó ở đó.'
              : 'Bài viết này có thể vẫn xuất hiện ở những nơi khác.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Hủy',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              isVisible ? 'Hiển thị' : 'Ẩn',
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
          isVisible
              ? 'Đã hiển thị trên trang cá nhân'
              : 'Đã ẩn khỏi trang cá nhân',
        );
      }
    } else {
      if (context.mounted) {
        showErrorSnackBar(context, 'Có lỗi xảy ra');
      }
    }
  }

  static Future<void> handleRemoveTag({
    required BuildContext context,
    required String postId,
    required Function() onSuccess,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Gỡ gắn thẻ'),
        content: const Text('Bạn có chắc muốn gỡ gắn thẻ khỏi bài viết này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Hủy',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Gỡ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await s1<RemoveTagUsecase>()(params: postId);

    if (result is DataStateSuccess) {
      onSuccess();
      if (context.mounted) {
        showSuccessSnackBar(context, 'Đã gỡ gắn thẻ');
      }
    } else {
      if (context.mounted) {
        showErrorSnackBar(context, 'Có lỗi xảy ra');
      }
    }
  }
}
