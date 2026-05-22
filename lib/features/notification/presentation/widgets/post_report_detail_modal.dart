import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class PostReportDetailModal extends StatelessWidget {
  final String postId;
  final String postTitle;
  final String status; // 'reviewed' hoặc 'rejected'
  final String? note;

  const PostReportDetailModal({
    super.key,
    required this.postId,
    required this.postTitle,
    required this.status,
    this.note,
  });

  static void show(
    BuildContext context, {
    required String postId,
    required String postTitle,
    required String status,
    String? note,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 16.h,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16.h,
          ),
          child: PostReportDetailModal(
            postId: postId,
            postTitle: postTitle,
            status: status,
            note: note,
          ),
        );
      },
    );
  }

  String _getStatusText(BuildContext context) {
    return status == 'reviewed'
        ? context.l10n.notificationReportReviewed
        : context.l10n.notificationReportRejected;
  }

  Color _getStatusColor() {
    return status == 'reviewed' ? Colors.red : Colors.green;
  }

  IconData _getStatusIcon() {
    return status == 'reviewed' ? Icons.visibility_off : Icons.cancel;
  }

  String _getReasonText(BuildContext context) {
    if (status == 'reviewed') {
      return context.l10n.notificationReportReviewedReason;
    } else {
      return context.l10n.notificationReportRejectedReason;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              context.l10n.notificationPostReportTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.close, size: 24.sp),
              onPressed: () => Navigator.pop(context),
              color: AppColors.textSecondary,
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Post Title
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.secondBackground,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.article_outlined,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.postLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      postTitle.isNotEmpty
                          ? postTitle
                          : context.l10n.postYourPost,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Status
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: _getStatusColor().withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(_getStatusIcon(), color: _getStatusColor(), size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  context.l10n.notificationReportStatus(
                    _getStatusText(context),
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Reason explanation
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.secondBackground,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    context.l10n.notificationExplanation,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                _getReasonText(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
              // Show note if exists
              if (note != null && note!.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: AppColors.divider, width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.note_outlined,
                        color: AppColors.textSecondary,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.notificationAdminNote,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              note!,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Close button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            child: Text(
              context.l10n.commonUnderstood,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
