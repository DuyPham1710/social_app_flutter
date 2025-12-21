import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/story/domain/entities/story_entity.dart';
import 'package:social_app_fe/features/story/presentation/bloc/home_stories_bloc.dart';

class StoryFooterWidget extends StatelessWidget {
  final TextEditingController textController;
  final StoryEntity story;
  final String? currentUserId;
  final bool isOwnStory;

  const StoryFooterWidget({
    super.key,
    required this.textController,
    required this.story,
    this.currentUserId,
    this.isOwnStory = false,
  });

  @override
  Widget build(BuildContext context) {
    // Nếu là story của chính mình, không hiển thị footer
    if (isOwnStory) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 16.h,
      child: Listener(
        // Sử dụng Listener để bắt pointer events và ngăn propagation
        onPointerDown: (_) {
          // Ngăn event propagation lên parent
        },
        child: SizedBox(
          height: 44.h, // Chiều cao cố định cho cả thanh cuộn
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w), // Padding cho 2 đầu
            children: [
              SizedBox(
                width: 230.w,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: TextField(
                    controller: textController,
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Send message...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                      ), // Màu xám nhạt
                    ),
                  ),
                ),
              ),

              ...EmojiType.values.map((emoji) {
                return Padding(
                  // Thêm padding bên trái cho mỗi icon để tạo khoảng cách
                  padding: EdgeInsets.only(left: 8.w),
                  child: _IconReaction(
                    emoji: emoji,
                    storyId: story.id,
                    isReacted: story.isReact == emoji,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget phụ trợ cho icon, chỉ dùng trong file này
class _IconReaction extends StatelessWidget {
  final EmojiType emoji;
  final String storyId;
  final bool isReacted;
  const _IconReaction({
    required this.emoji,
    required this.storyId,
    this.isReacted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ngăn event propagation
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Gọi bloc để react story (nếu đã react sẽ xóa, nếu chưa sẽ tạo)
        context.read<HomeStoriesBloc>().add(
          ReactStoryEvent(
            storyId: storyId,
            emojiId: emoji.id,
          ),
        );
      },
      child: Container(
        width: 56.w,
        height: 56.w,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: isReacted 
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: isReacted
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: isReacted
            ? Text(
                emoji.icon,
                style: TextStyle(fontSize: 32.sp),
              )
            : Lottie.asset(
                emoji.lottieAsset,
                fit: BoxFit.contain,
                repeat: true,
              ),
      ),
    );
  }
}
