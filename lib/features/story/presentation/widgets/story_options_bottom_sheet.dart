import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool _isArchiving = false;

  Future<void> _archiveStory(BuildContext context) async {
    final storyId = widget.currentGroup.stories[widget.currentStoryIndex].id;

    // Hiển thị dialog xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.archive_outlined,
                    size: 32.r,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.storyArchiveTitle,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  context.l10n.storyArchiveConfirm,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            side: BorderSide(color: AppColors.divider),
                          ),
                          backgroundColor: AppColors.secondBackground,
                        ),
                        child: Text(
                          context.l10n.commonCancel,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          context.l10n.commonConfirm,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
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

    setState(() {
      _isArchiving = true;
    });

    try {
      final result = await _storyRepository.archiveStory(storyId: storyId);

      if (mounted) {
        Navigator.pop(context); // Đóng bottom sheet

        if (result is DataStateSuccess) {
          // Reload danh sách story trước khi đóng story viewer
          try {
            final navigator = Navigator.of(context, rootNavigator: false);
            final rootContext = navigator.context;
            final homeStoriesBloc = rootContext.read<HomeStoriesBloc>();
            homeStoriesBloc.add(const LoadHomeStoriesEvent(page: 1, limit: 10));
          } catch (e) {
            try {
              final homeStoriesBloc = context.read<HomeStoriesBloc>();
              homeStoriesBloc.add(
                const LoadHomeStoriesEvent(page: 1, limit: 10),
              );
            } catch (_) {}
          }

          // Đóng story viewer và quay về màn hình trước
          Navigator.of(context).pop();

          // Hiển thị thông báo thành công
          showSuccessSnackBar(context, context.l10n.storyArchived);
        } else if (result is DataStateError) {
          showErrorSnackBar(
            context,
            context.l10n.commonErrorWithMessage(
              result.error?.message ?? context.l10n.storyArchiveFailed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showErrorSnackBar(context, context.l10n.commonErrorWithMessage('$e'));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isArchiving = false;
        });
      }
    }
  }

  Future<void> _deleteStory(BuildContext context) async {
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

      if (mounted) {
        Navigator.pop(context); // Đóng bottom sheet

        if (result is DataStateSuccess) {
          // Reload danh sách story trước khi đóng story viewer
          // HomeStoriesBloc được provide ở main.dart nên có thể truy cập từ bất kỳ context nào
          try {
            // Sử dụng rootNavigator để tìm context có HomeStoriesBloc
            final navigator = Navigator.of(context, rootNavigator: false);
            final rootContext = navigator.context;
            final homeStoriesBloc = rootContext.read<HomeStoriesBloc>();
            homeStoriesBloc.add(const LoadHomeStoriesEvent(page: 1, limit: 10));
          } catch (e) {
            // Nếu không tìm thấy, thử tìm trong context hiện tại
            try {
              final homeStoriesBloc = context.read<HomeStoriesBloc>();
              homeStoriesBloc.add(
                const LoadHomeStoriesEvent(page: 1, limit: 10),
              );
            } catch (_) {
              // Nếu vẫn không tìm thấy, không sao - story đã được xóa trên server
              // Khi user quay lại trang home, story sẽ tự động không còn trong danh sách
            }
          }

          // Đóng story viewer và quay về màn hình trước
          Navigator.of(context).pop();

          // Hiển thị thông báo thành công
          showSuccessSnackBar(context, context.l10n.storyDeleted);
        } else if (result is DataStateError) {
          showErrorSnackBar(
            context,
            context.l10n.commonErrorWithMessage(
              result.error?.message ?? context.l10n.storyDeleteFailed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showErrorSnackBar(context, context.l10n.commonErrorWithMessage('$e'));
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
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
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
              onTap: _isDeleting ? null : () => _deleteStory(context),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
