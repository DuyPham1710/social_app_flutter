import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final String ? currentUserAvatar;

  const CommentInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.currentUserAvatar,
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(
          context,
        ).viewInsets.bottom, // đẩy lên khi bàn phím mở
        left: 16.w,
        right: 10.w,
        top: 8.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundImage: NetworkImage(
              currentUserAvatar ??
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
            ),
          ),
          SizedBox(width: 10.w),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(color: Colors.transparent),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'What do you think of this?',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 5,
              ),
            ),
          ),

          SizedBox(width: 6.w),

          IconButton(
            icon: Icon(
              CupertinoIcons.paperplane_fill,
              color: Colors.blueAccent,
              size: 24.sp,
            ),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
