import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class FriendHeaderChips extends StatelessWidget {
  const FriendHeaderChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildChip(label: '54 người đang online', leading: _buildOnlineDot()),
        SizedBox(width: 8.w),
        _buildChip(label: 'Bạn bè'),
        SizedBox(width: 8.w),
        _buildChip(label: 'Gợi ý'),
      ],
    );
  }

  Widget _buildOnlineDot() {
    return Container(
      width: 8.r,
      height: 8.r,
      decoration: const BoxDecoration(
        color: Color(0xFF2CD45C),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildChip({required String label, Widget? leading}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading,
            SizedBox(width: 6.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}



