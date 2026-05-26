import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_state.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/presentation/pages/reaction_details_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommentHeaderWidget extends StatelessWidget {
  final String postId;
  final List<ReactPostEntity>? reacts;
  final Function(
    String userId,
    String userAvatar,
    String? parentId,
    String userDisplayName,
  )?
  onMention;

  const CommentHeaderWidget({
    super.key,
    required this.postId,
    this.reacts,
    this.onMention,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // Nếu có reacts parameter thì dùng nó, ngược lại lấy từ HomeBloc
        List<ReactPostEntity>? displayReacts = reacts;

        if (displayReacts == null && state is HomeLoaded) {
          try {
            final post = state.posts?.firstWhere((p) => p.id == postId);
            displayReacts = post?.reacts;
          } catch (e) {
            // Post không tìm thấy
            displayReacts = null;
          }
        }

        // Tính toán dữ liệu reacts
        final reactCount = displayReacts?.length ?? 0;
        final Map<EmojiType, int> emojiCounts = {};

        if (displayReacts != null) {
          for (var react in displayReacts) {
            emojiCounts[react.emoji] = (emojiCounts[react.emoji] ?? 0) + 1;
          }
        }

        // Lấy top 2 emoji phổ biến nhất
        final sortedEmojis = emojiCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final topEmojis = sortedEmojis.take(2).toList();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Chỉ điều hướng nếu có reacts
                  if (displayReacts != null && displayReacts.isNotEmpty) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ReactionDetailsPage(
                          reacts: displayReacts!,
                          postId: postId,
                          onMention: onMention,
                        ),
                      ),
                    );
                  }
                },
                child: Row(
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
                                left: i * 18.0,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.background,
                                  child: Text(
                                    topEmojis[i].key.icon,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    else
                      // Placeholder khi không có react
                      SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Icon(
                          CupertinoIcons.hand_thumbsup,
                          color: AppColors.unselectedIcon,
                          size: 20.sp,
                        ),
                      ),

                    Container(
                      width: 10.w,
                      height: 24.h,
                      color: AppColors.background,
                    ),

                    Text(
                      reactCount.toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Container(
                      width: 30.w,
                      height: 24.h,
                      color: AppColors.background,
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed: () {},
                child: Text(
                  context.l10n.postShareCount(0),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
