import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/privacy_util.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/usecases/delete_post_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/update_post_tags_usecase.dart';
import 'package:social_app_fe/features/post/presentation/pages/tag_friends_page.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_bloc.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_event.dart';
import 'package:social_app_fe/features/privacy/presentation/page/privacy_page.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_option_item_widget.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class PostOptionsBottomSheet extends StatefulWidget {
  final PostEntity post;
  final bool showOwnerActions;
  final VoidCallback? onDeleted;

  const PostOptionsBottomSheet({
    super.key,
    required this.post,
    this.showOwnerActions = true,
    this.onDeleted,
  });

  @override
  State<PostOptionsBottomSheet> createState() => _PostOptionsBottomSheetState();

  static void show(
    BuildContext context, {
    required PostEntity post,
    bool showOwnerActions = true,
    VoidCallback? onDeleted,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PostOptionsBottomSheet(
          post: post,
          showOwnerActions: showOwnerActions,
          onDeleted: onDeleted,
        );
      },
    );
  }
}

class _PostOptionsBottomSheetState extends State<PostOptionsBottomSheet> {
  bool _isDeleting = false;

  Future<void> _deletePost(BuildContext context) async {
    final postId = widget.post.id;
    final parentContext = Navigator.of(context).context;

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
      final result = await resolveDeletePostUsecase()(
        params: DeletePostParams(postId: postId),
      );

      if (mounted) {
        Navigator.pop(context); // Đóng bottom sheet

        if (result is DataStateSuccess) {
          // Hiển thị thông báo thành công
          showSuccessSnackBar(parentContext, 'Đã xóa bài viết');
          widget.onDeleted?.call();
        } else if (result is DataStateError) {
          showErrorSnackBar(
            parentContext,
            'Lỗi: ${result.error?.message ?? "Không thể xóa bài viết"}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showErrorSnackBar(parentContext, 'Lỗi: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Future<void> _updatePostTags(BuildContext context) async {
    final parentContext = Navigator.of(context).context;
    Navigator.pop(context); // Đóng bottom sheet trước

    final currentTaggedIds =
        widget.post.taggedUsers?.map((u) => u.userId).toList() ?? [];

    final result = await Navigator.push(
      parentContext,
      CupertinoPageRoute(
        builder: (_) =>
            TagFriendsPage(initialSelectedFriends: currentTaggedIds),
      ),
    );

    if (result != null && result is List<Map<String, String>>) {
      final newTaggedIds = result.map((e) => e['id']!).toList();

      final updateResult = await s1<UpdatePostTagsUsecase>()(
        params: UpdatePostTagsParams(
          postId: widget.post.id,
          taggedUserIds: newTaggedIds,
        ),
      );

      if (parentContext.mounted) {
        if (updateResult is DataStateSuccess) {
          showSuccessSnackBar(parentContext, 'Đã cập nhật gắn thẻ');
        } else {
          showErrorSnackBar(
            parentContext,
            'Có lỗi xảy ra khi cập nhật gắn thẻ',
          );
        }
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
            if (widget.showOwnerActions) ...[
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
                        create: (_) => s1<PrivacyBloc>()
                          ..add(GetDefaultPrivacyRequested()),
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
                icon: Icons.person_add_alt_1_outlined,
                title: "Gắn thẻ bạn bè",
                onTap: () => _updatePostTags(context),
              ),
            ],
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
