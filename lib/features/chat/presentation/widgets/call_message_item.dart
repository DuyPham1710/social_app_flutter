import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class VideoCallMessageItem extends StatelessWidget {
  final bool fromMe;
  final String callType; // 'video' or 'audio'
  final String callStatus; // 'completed', 'missed', 'rejected'
  final int? duration; // in seconds (null if missed/rejected)
  final DateTime timestamp;
  final VoidCallback? onCallAgain;

  const VideoCallMessageItem({
    super.key,
    required this.fromMe,
    required this.callType,
    required this.callStatus,
    this.duration,
    required this.timestamp,
    this.onCallAgain,
  });

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '0:${secs.toString().padLeft(2, '0')}';
  }

  String _getStatusText() {
    switch (callStatus) {
      case 'completed':
        return duration != null ? _formatDuration(duration!) : 'Cuộc gọi video';
      case 'missed':
        return 'Nhỡ cuộc gọi';
      case 'rejected':
        return 'Đã bỏ lỡ cuộc gọi video';
      default:
        return 'Cuộc gọi video';
    }
  }

  Color _getStatusColor() {
    if (callStatus == 'missed' || callStatus == 'rejected') {
      return Colors.red;
    }
    return AppColors.textSecondary;
  }

  IconData _getCallIcon() {
    if (callType == 'video') {
      return CupertinoIcons.video_camera_solid;
    } else if (callType == 'audio' && callStatus != 'completed') {
      return CupertinoIcons.phone_fill_badge_plus;
    } else {
      return CupertinoIcons.phone_fill_arrow_up_right;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.transparent, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),

            child: Icon(_getCallIcon(), color: Colors.white, size: 20.sp),
          ),

          SizedBox(width: 12.w),

          // Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                callType == 'video' ? 'Cuộc gọi video' : 'Cuộc gọi thoại',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 2.h),

              Row(
                children: [
                  // Status icon
                  if (callStatus == 'missed' || callStatus == 'rejected')
                    Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Icon(
                        CupertinoIcons.phone_down_fill,
                        color: Colors.red,
                        size: 12.sp,
                      ),
                    )
                  else if (callStatus == 'completed')
                    Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Icon(
                        CupertinoIcons.checkmark_alt,
                        color: AppColors.textSecondary,
                        size: 14.sp,
                      ),
                    ),

                  Text(
                    _getStatusText(),
                    style: TextStyle(fontSize: 12.sp, color: _getStatusColor()),
                  ),
                ],
              ),
            ],
          ),

          // Call again button (nếu không phải missed)
          if (callStatus == 'completed') ...[
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: onCallAgain,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCallIcon(),
                  color: AppColors.primary,
                  size: 16.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
