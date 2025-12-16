import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class ScrollToBottomButton extends StatelessWidget {
  final bool show;
  final VoidCallback onPressed;

  const ScrollToBottomButton({
    super.key,
    required this.show,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: !show, // Không cho bấm khi nút đang ẩn
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: AppColors.textSecondary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.keyboard_double_arrow_down,
              size: 18.sp,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
