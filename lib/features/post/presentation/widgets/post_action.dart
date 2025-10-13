import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/modal_comment.dart';

class PostAction extends StatelessWidget {
  final String postId;
  final int commentCount;

  const PostAction({super.key, required this.postId, this.commentCount = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 24.sp),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return ModalComment(postId: postId);
                    },
                  );
                },
                child: Text("144", style: TextStyle(fontSize: 12.sp)),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return ModalComment(postId: postId, isPressComment: true);
                    },
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.chat_bubble,
                      color: Colors.black87,
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text("$commentCount", style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return ModalComment(postId: postId, isPressComment: true);
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                commentCount > 0
                    ? "View all $commentCount comment${commentCount > 1 ? 's' : ''}"
                    : "No comments yet",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
