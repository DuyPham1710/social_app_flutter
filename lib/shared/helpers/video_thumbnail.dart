import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Build video thumbnail with play icon overlay
Widget buildVideoThumbnail() {
  return Stack(
    children: [
      Container(
        width: double.infinity,
        height: 300.h,
        color: Colors.black,
        child: Center(
          child: Icon(Icons.videocam, color: Colors.white54, size: 48.sp),
        ),
      ),
      Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 64.sp,
            ),
          ),
        ),
      ),
    ],
  );
}
