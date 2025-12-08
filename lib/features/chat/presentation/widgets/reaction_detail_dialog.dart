import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';

class ReactionDetailDialog extends StatefulWidget {
  final List<ReactionEntity> reactions;

  const ReactionDetailDialog({super.key, required this.reactions});

  @override
  State<ReactionDetailDialog> createState() => _ReactionDetailDialogState();
}

class _ReactionDetailDialogState extends State<ReactionDetailDialog> {
  // Biến lưu trạng thái emoji đang chọn. Null nghĩa là chọn "TẤT CẢ"
  String? _selectedEmoji;

  @override
  Widget build(BuildContext context) {
    // Logic lọc danh sách dựa trên emoji đang chọn
    final filteredReactions = _selectedEmoji == null
        ? widget.reactions
        : widget.reactions
              .where((r) => r.emoji.icon == _selectedEmoji)
              .toList();

    // Tính toán số lượng cho từng emoji
    final emojiCounts = widget.reactions.fold<Map<String, int>>({}, (
      map,
      reaction,
    ) {
      final icon = reaction.emoji.icon;
      map[icon] = (map[icon] ?? 0) + 1;
      return map;
    });

    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        height: 0.5.sh,
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // --- HEADER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cảm xúc",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.secondBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // BODY
            Expanded(
              child: filteredReactions.isEmpty
                  ? Center(
                      child: Text(
                        "Chưa có cảm xúc nào",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredReactions.length,
                      separatorBuilder: (ctx, index) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final reaction = filteredReactions[index];
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundImage: NetworkImage(
                                reaction.user.avatarUrl ??
                                    "https://i.pravatar.cc/300",
                              ),
                              backgroundColor: Colors.grey.shade200,
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Text(
                                reaction.user.fullName ?? "Người dùng ẩn danh",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),

                            Text(
                              reaction.emoji.icon,
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ],
                        );
                      },
                    ),
            ),

            SizedBox(height: 16.h),

            // FOOTER: FILTER TABS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tab "TẤT CẢ"
                  _buildFilterTab(
                    label: "TẤT CẢ",
                    isSelected: _selectedEmoji == null,
                    onTap: () {
                      setState(() {
                        _selectedEmoji = null;
                      });
                    },
                  ),

                  // Các Tab Emoji
                  ...emojiCounts.entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: _buildFilterTab(
                        emojiIcon: entry.key,
                        count: entry.value,
                        isSelected: _selectedEmoji == entry.key,
                        onTap: () {
                          setState(() {
                            _selectedEmoji = entry.key;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab({
    String? label,
    String? emojiIcon,
    int? count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          // Đổi màu nền dựa trên trạng thái chọn
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null)
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,

                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),

            if (emojiIcon != null) ...[
              Text(emojiIcon, style: TextStyle(fontSize: 14.sp)),

              SizedBox(width: 4.w),

              Text(
                "$count",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
