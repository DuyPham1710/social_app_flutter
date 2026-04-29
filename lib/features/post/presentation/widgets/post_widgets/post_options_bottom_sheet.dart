import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/privacy_util.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_bloc.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_event.dart';
import 'package:social_app_fe/features/privacy/presentation/page/privacy_page.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_option_item_widget.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class PostOptionsBottomSheet extends StatefulWidget {
  final PostEntity post;

  const PostOptionsBottomSheet({super.key, required this.post});

  @override
  State<PostOptionsBottomSheet> createState() => _PostOptionsBottomSheetState();

  static void show(BuildContext context, {required PostEntity post}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PostOptionsBottomSheet(post: post);
      },
    );
  }
}

class _PostOptionsBottomSheetState extends State<PostOptionsBottomSheet> {
  final PostRepository _postRepository = s1<PostRepository>();
  bool _isDeleting = false;

  Future<void> _deletePost(BuildContext context) async {
    final postId = widget.post.id;

    // Hiển thị dialog xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2E),
          title: const Text(
            'Xóa bài viết',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn xóa bài viết này không?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
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
      final result = await _postRepository.deletePost(postId: postId);

      if (mounted) {
        Navigator.pop(context); // Đóng bottom sheet

        if (result is DataStateSuccess) {
          // Hiển thị thông báo thành công
          showSuccessSnackBar(context, 'Đã xóa bài viết');
        } else if (result is DataStateError) {
          showErrorSnackBar(
            context,
            'Lỗi: ${result.error?.message ?? "Không thể xóa bài viết"}',
          );
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
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            StoryOptionItemWidget(
              icon: Icons.lock_outline,
              title: "Chỉnh sửa quyền riêng tư của bài viết",
              onTap: () {
                Navigator.pop(context);
                final privacyLabel = PrivacyUtil.privacyTypeToLabel(
                  widget.post.privacyType,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) =>
                          s1<PrivacyBloc>()..add(GetDefaultPrivacyRequested()),
                      child: PrivacyPage(
                        selectedOption: privacyLabel,
                        postId: widget.post.id,
                        initialPrivacyType: widget.post.privacyType,
                        initialFriendsExcept: widget.post.friendsExcept,
                        initialFriendsDetail: widget.post.friendsDetail,
                      ),
                    ),
                  ),
                );
              },
            ),
            StoryOptionItemWidget(
              icon: Icons.lock_outline,
              title: "Gắn thẻ bạn bè",
              onTap: () {},
            ),
            StoryOptionItemWidget(
              icon: Icons.delete_outline,
              title: "Xóa bài viết",
              onTap: _isDeleting ? null : () => _deletePost(context),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
