import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';

class StoryFooterWidget extends StatelessWidget {
  final TextEditingController textController;

  const StoryFooterWidget({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16.h,
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
                child: _IconReaction(emoji: emoji),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Widget phụ trợ cho icon, chỉ dùng trong file này
class _IconReaction extends StatelessWidget {
  final EmojiType emoji;
  const _IconReaction({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Reacted: ${emoji.label}')));
      },
      child: Container(
        width: 56.w,
        height: 56.w,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Lottie.asset(
          emoji.lottieAsset,
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
}
