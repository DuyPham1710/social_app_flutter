import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class PostAction extends StatelessWidget {
  const PostAction({super.key});

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
              Text("144", style: TextStyle(fontSize: 12.sp)),
              SizedBox(width: 16.w),
              Icon(
                CupertinoIcons.chat_bubble,
                color: Colors.black87,
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text("57", style: TextStyle(fontSize: 12.sp)),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              "View all 57 comments",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
