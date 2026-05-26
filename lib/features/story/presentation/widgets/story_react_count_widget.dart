import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/story/domain/entities/story_entity.dart';

class StoryReactCountWidget extends StatelessWidget {
  final StoryEntity story;
  final VoidCallback onTap;

  const StoryReactCountWidget({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final reacts = story.reacts;
    final reactCount = reacts.length;

    if (reactCount == 0) {
      return const SizedBox.shrink();
    }

    // Đếm số lượng từng emoji
    final Map<EmojiType, int> emojiCount = {};
    for (var react in reacts) {
      emojiCount[react.emoji] = (emojiCount[react.emoji] ?? 0) + 1;
    }

    // Sắp xếp giảm dần theo số lượng
    final sortedEmojis = emojiCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Lấy tối đa 2 emoji phổ biến nhất
    final topEmojis = sortedEmojis.take(2).toList();

    return Positioned(
      left: 12.w,
      bottom: 16.h,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hiển thị emoji icons
              if (topEmojis.isNotEmpty)
                SizedBox(
                  width: topEmojis.length > 1 ? 40.w : 24.w,
                  height: 24.h,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (int i = 0; i < topEmojis.length; i++)
                        Positioned(
                          left: (i * 18).w,
                          child: Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                topEmojis[i].key.icon,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              if (topEmojis.isNotEmpty) SizedBox(width: 8.w),
              // Hiển thị số lượng
              Text(
                reactCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
