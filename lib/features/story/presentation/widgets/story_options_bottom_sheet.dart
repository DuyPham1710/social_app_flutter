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
  State<StoryOptionsBottomSheet> createState() => _StoryOptionsBottomSheetState();

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

  Future<void> _deleteStory(BuildContext context) async {
    final storyId = widget.currentGroup.stories[widget.currentStoryIndex].id;
    
    // Hiển thị dialog xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Xóa tin',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa tin này không?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Hủy',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
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
              homeStoriesBloc.add(const LoadHomeStoriesEvent(page: 1, limit: 10));
            } catch (_) {
              // Nếu vẫn không tìm thấy, không sao - story đã được xóa trên server
              // Khi user quay lại trang home, story sẽ tự động không còn trong danh sách
            }
          }
          
          // Đóng story viewer và quay về màn hình trước
          Navigator.of(context).pop();
          
          // Hiển thị thông báo thành công
          showSuccessSnackBar(context, 'Đã xóa tin');
        } else if (result is DataStateError) {
          showErrorSnackBar(context, 'Lỗi: ${result.error?.message ?? "Không thể xóa tin"}');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showErrorSnackBar(context, 'Lỗi: $e');
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
              title: "Chỉnh sửa quyền riêng tư của tin",
              onTap: () {
                Navigator.pop(context);
                final storyId = widget.currentGroup.stories[widget.currentStoryIndex].id;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StoryPrivacySettingsPage(
                      storyId: storyId,
                    ),
                  ),
                );
              },
            ),
            StoryOptionItemWidget(
              icon: Icons.message_outlined,
              title: "Gửi bằng Messenger",
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement Messenger sharing
              },
            ),
            StoryOptionItemWidget(
              icon: Icons.download_outlined,
              title: "Lưu ảnh",
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement save photo
              },
            ),
            StoryOptionItemWidget(
              icon: Icons.archive_outlined,
              title: "Lưu trữ ảnh",
              subtitle: "Gỡ ảnh khỏi tin và lưu vào kho lưu trữ.",
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement archive photo
              },
            ),
            StoryOptionItemWidget(
              icon: Icons.delete_outline,
              title: "Xóa ảnh",
              onTap: _isDeleting ? null : () => _deleteStory(context),
            ),
            StoryOptionItemWidget(
              icon: Icons.link_outlined,
              title: "Sao chép liên kết để chia sẻ tin này",
              subtitle:
                  "Tin sẽ hiển thị với đối tượng của ${widget.currentGroup.user.fullName ?? 'bạn'} trong 24 giờ.",
              onTap: () {
                Navigator.pop(context);
                final storyId = widget.currentGroup.stories[widget.currentStoryIndex].id;
                Clipboard.setData(ClipboardData(text: 'story://$storyId'));
                showSuccessSnackBar(context, 'Đã sao chép liên kết');
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

}

