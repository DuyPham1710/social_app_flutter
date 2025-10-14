import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  const CommentInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
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
              'https://i.pinimg.com/736x/8b/28/8d/8b288dbd8cb07d0f85adc8bdd7006ecc.jpg',
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
