import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_privacy_settings_page.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_option_item_widget.dart';

class StoryOptionsBottomSheet extends StatelessWidget {
  final GroupedUserStoryEntity currentGroup;
  final int currentStoryIndex;

  const StoryOptionsBottomSheet({
    super.key,
    required this.currentGroup,
    required this.currentStoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
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
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            StoryOptionItemWidget(
              icon: Icons.lock_outline,
              title: "Chỉnh sửa quyền riêng tư của tin",
              onTap: () {
                Navigator.pop(context);
                final storyId = currentGroup.stories[currentStoryIndex].id;
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
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete photo
              },
            ),
            StoryOptionItemWidget(
              icon: Icons.link_outlined,
              title: "Sao chép liên kết để chia sẻ tin này",
              subtitle:
                  "Tin sẽ hiển thị với đối tượng của ${currentGroup.user.fullName ?? 'bạn'} trong 24 giờ.",
              onTap: () {
                Navigator.pop(context);
                final storyId = currentGroup.stories[currentStoryIndex].id;
                Clipboard.setData(ClipboardData(text: 'story://$storyId'));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Đã sao chép liên kết'),
                    backgroundColor: Colors.grey[800],
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

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

