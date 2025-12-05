import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
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

    return FutureBuilder<Map<String, dynamic>?>(
      future: TokenStorage.getUserData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final currentUserId = snapshot.data?['id'];

        // Kiểm tra xem user hiện tại có react hay không
        final hasCurrentUserReacted = reacts!.any(
          (r) => r.user.userId == currentUserId,
        );

        // Danh sách react còn lại (không tính current user)
        final otherReacts = reacts!
            .where((r) => r.user.userId != currentUserId)
            .toList();

        String displayText;

        if (hasCurrentUserReacted) {
          if (otherReacts.isEmpty) {
            displayText = "You reacted to this";
          } else {
            displayText = "You and ${otherReacts.length} others";
          }
        } else {
          // Nếu current user chưa react
          final firstUser =
              reacts!.first.user.fullName?.trim().split(" ").last ?? "Someone";
          final othersCount = reacts!.length - 1;
          if (othersCount > 0) {
            displayText = "$firstUser and $othersCount others";
          } else {
            displayText = firstUser;
          }
        }

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
                child: Text(displayText, style: TextStyle(fontSize: 12.sp)),
              ),
            ],
          ),
        );
      },
    );
  }
}
