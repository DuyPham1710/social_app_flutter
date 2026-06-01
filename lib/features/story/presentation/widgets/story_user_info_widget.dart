import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_options_bottom_sheet.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class StoryUserInfoWidget extends StatelessWidget {
  final GroupedUserStoryEntity currentGroup;
  final int currentStoryIndex;
  final String? currentUserId;
  final VoidCallback onClose;

  const StoryUserInfoWidget({
    super.key,
    required this.currentGroup,
    required this.currentStoryIndex,
    this.currentUserId,
    required this.onClose,
  });

  String _timeAgo(BuildContext context, DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes == 0) return context.l10n.postJustNow;
    if (diff.inMinutes < 60) return context.l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return context.l10n.timeHoursAgo(diff.inHours);
    return context.l10n.timeDaysAgo(diff.inDays);
  }

  bool get _isMyStory =>
      currentUserId != null && currentGroup.user.userId == currentUserId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundImage: NetworkImage(
              currentGroup.user.avatarUrl ??
                  'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isMyStory
                      ? context.l10n.chatYourStory
                      : (currentGroup.user.fullName ?? context.l10n.commonUser),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  currentGroup.stories[currentStoryIndex].createdAt != null
                      ? _timeAgo(
                          context,
                          currentGroup.stories[currentStoryIndex].createdAt!,
                        )
                      : context.l10n.postUnknownTime,
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_isMyStory) {
                StoryOptionsBottomSheet.show(
                  context,
                  currentGroup: currentGroup,
                  currentStoryIndex: currentStoryIndex,
                );
              } else {
                onClose();
              }
            },
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isMyStory ? Icons.more_vert : Icons.close,
                color: Colors.white,
                size: 25.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
