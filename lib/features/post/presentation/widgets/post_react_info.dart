import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';

class PostReactInfo extends StatelessWidget {
  final List<ReactPostEntity>? reacts;
  const PostReactInfo({super.key, this.reacts});

  @override
  Widget build(BuildContext context) {
    final hasReacts = reacts != null && reacts!.isNotEmpty;

    if (!hasReacts) {
      return SizedBox.shrink();
    }

    // Đếm số lượng từng emoji
    final Map<EmojiType, int> emojiCount = {};
    for (var react in reacts!) {
      emojiCount[react.emoji] = (emojiCount[react.emoji] ?? 0) + 1;
    }

    // Sắp xếp giảm dần theo số lượng
    final sortedEmojis = emojiCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Lấy tối đa 2 emoji phổ biến nhất
    final topEmojis = sortedEmojis.take(2).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (int i = 0; i < topEmojis.length; i++)
                  Positioned(
                    left: (i * 18),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Text(
                        topEmojis[i].key.icon,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: 30.w),

          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Liked by ",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  TextSpan(
                    text: reacts![0].user.username,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (reacts!.length > 1) ...[
                    TextSpan(
                      text: " and ${reacts!.length - 1} others",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
