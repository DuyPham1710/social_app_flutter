import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class MessageMoreOptionsDialog {
  static void show({
    required BuildContext context,
    required bool fromMe,
    required bool isFifteenMinutes,
    VoidCallback? onDelete,
    VoidCallback? onEdit,
    VoidCallback? onPin,
    VoidCallback? onForward,
    VoidCallback? onReport,
    VoidCallback? onCreateAIImage,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: _MessageMoreOptionsContent(
          fromMe: fromMe,
          isFifteenMinutes: isFifteenMinutes,
          onDelete: onDelete,
          onEdit: onEdit,
          onPin: onPin,
          onForward: onForward,
          onReport: onReport,
          onCreateAIImage: onCreateAIImage,
        ),
      ),
    );
  }
}

class _MessageMoreOptionsContent extends StatelessWidget {
  final bool fromMe;
  final bool isFifteenMinutes;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onPin;
  final VoidCallback? onForward;
  final VoidCallback? onReport;
  final VoidCallback? onCreateAIImage;

  const _MessageMoreOptionsContent({
    required this.fromMe,
    required this.isFifteenMinutes,
    this.onDelete,
    this.onEdit,
    this.onPin,
    this.onForward,
    this.onReport,
    this.onCreateAIImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Khác',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.textSecondary.withOpacity(0.2),
          ),

          // Options
          _buildOption(
            icon: CupertinoIcons.trash_fill,
            label: 'Xóa',
            onTap: () {
              Navigator.of(context).pop();
              if (onDelete != null) onDelete!();
            },
          ),

          if (fromMe && isFifteenMinutes && onEdit != null)
            _buildOption(
              icon: CupertinoIcons.pencil,
              label: 'Chỉnh sửa',
              onTap: () {
                Navigator.of(context).pop();
                if (onEdit != null) onEdit!();
              },
            ),

          _buildOption(
            icon: CupertinoIcons.pin_fill,
            label: 'Ghim',
            onTap: () {
              Navigator.of(context).pop();
              if (onPin != null) onPin!();
            },
          ),

          _buildOption(
            icon: CupertinoIcons.arrowshape_turn_up_right_fill,
            label: 'Chuyển tiếp',
            onTap: () {
              Navigator.of(context).pop();
              if (onForward != null) onForward!();
            },
          ),

          _buildOption(
            icon: CupertinoIcons.exclamationmark_triangle_fill,
            label: 'Báo cáo',
            onTap: () {
              Navigator.of(context).pop();
              if (onReport != null) onReport!();
            },
          ),

          _buildOption(
            icon: CupertinoIcons.sparkles,
            label: 'Tạo hình ảnh AI',
            onTap: () {
              Navigator.of(context).pop();
              if (onCreateAIImage != null) onCreateAIImage!();
            },
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textPrimary, size: 20.sp),
              SizedBox(width: 16.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
