import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class CallFeedbackScreen extends StatefulWidget {
  final String callerName;
  final String? callerAvatar;
  final int callDuration; // in seconds
  final bool wasRejected; // true nếu bị từ chối
  final VoidCallback onClose;

  const CallFeedbackScreen({
    super.key,
    required this.callerName,
    this.callerAvatar,
    required this.callDuration,
    this.wasRejected = false,
    required this.onClose,
  });

  @override
  State<CallFeedbackScreen> createState() => _CallFeedbackScreenState();
}

class _CallFeedbackScreenState extends State<CallFeedbackScreen> {
  int? _selectedRating; // 1 = Tốt, 0 = Không tốt

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) {
      return '$minutes phút $secs giây';
    }
    return '$secs giây';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Close button
            widget.wasRejected
                ? SizedBox.shrink()
                : Positioned(
                    top: 20.h,
                    right: 20.w,
                    child: GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),

            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar
                  if (widget.callerAvatar != null)
                    CircleAvatar(
                      radius: 40.r,
                      backgroundImage: NetworkImage(widget.callerAvatar!),
                    )
                  else
                    CircleAvatar(
                      radius: 40.r,
                      child: Icon(CupertinoIcons.person, size: 40.sp),
                    ),

                  SizedBox(height: 20.h),

                  // Tên
                  Text(
                    widget.callerName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Status
                  if (widget.wasRejected)
                    Column(
                      children: [
                        Icon(
                          CupertinoIcons.phone_down_fill,
                          color: Colors.red,
                          size: 30.sp,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Không trả lời',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text(
                          'Cuộc gọi đã kết thúc',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          _formatDuration(widget.callDuration),
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: 40.h),

                  // Feedback section (chỉ hiện khi không bị reject)
                  if (!widget.wasRejected) ...[
                    Text(
                      'Bạn thấy chất lượng cuộc gọi như thế nào?',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 30.h),

                    // Rating buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tốt button
                        _buildRatingButton(
                          icon: CupertinoIcons.hand_thumbsup_fill,
                          label: 'Tốt',
                          isSelected: _selectedRating == 1,
                          onTap: () {
                            setState(() {
                              _selectedRating = 1;
                            });
                          },
                          selectedColor: AppColors.primary,
                        ),

                        SizedBox(width: 60.w),

                        _buildRatingButton(
                          icon: CupertinoIcons.hand_thumbsdown_fill,
                          label: 'Không tốt',
                          isSelected: _selectedRating == 0,
                          onTap: () {
                            setState(() {
                              _selectedRating = 0;
                            });
                          },
                          selectedColor: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Bottom button
            Positioned(
              bottom: 40.h,
              left: 40.w,
              right: 40.w,
              child: Column(
                children: [
                  // Submit feedback button (nếu có rating)
                  if (_selectedRating != null && !widget.wasRejected)
                    Container(
                      width: double.infinity,
                      height: 50.h,
                      margin: EdgeInsets.only(bottom: 10.h),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Submit feedback to backend
                          widget.onClose();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          'Gửi đánh giá',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // Close button
                  !widget.wasRejected
                      ? SizedBox.shrink()
                      : Positioned(
                          bottom: 80.h,
                          child: GestureDetector(
                            onTap: widget.onClose,
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.xmark,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color selectedColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? selectedColor.withOpacity(0.3)
                  : Colors.white24,
              border: Border.all(
                color: isSelected ? selectedColor : Colors.transparent,
                width: 3,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? selectedColor : Colors.white,
              size: 20.sp,
            ),
          ),

          SizedBox(height: 10.h),

          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
