import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class FriendSuggestionItem extends StatelessWidget {
  final String name;
  final int mutualFriends;
  final String avatarUrl;
  final List<String>? mutualFriendAvatars;
  final VoidCallback? onAddFriend;
  final VoidCallback? onRemove;
  final bool isSent;

  const FriendSuggestionItem({
    super.key,
    required this.name,
    required this.mutualFriends,
    required this.avatarUrl,
    this.mutualFriendAvatars,
    this.onAddFriend,
    this.onRemove,
    this.isSent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Quan trọng: căn chỉnh lên đầu
        children: [
          // Avatar
          CircleAvatar(radius: 32.r, backgroundImage: NetworkImage(avatarUrl)),
          SizedBox(width: 12.w),

          // Phần Tên, Bạn chung và Nút
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),

                // Bạn chung - chỉ hiển thị khi có bạn chung
                if (mutualFriends > 0) ...[
                  Row(
                    children: [
                      _buildMutualFriendAvatars(),
                      SizedBox(width: 6.w),
                      Text(
                        '$mutualFriends bạn chung',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h), // Khoảng cách giữa thông tin và nút
                ],

                // Nếu không có bạn chung, thêm space nhỏ hơn
                if (mutualFriends == 0) SizedBox(height: 4.h),

                // Các Nút hoặc thông báo
                if (isSent)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 16.w,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.blue[200]!, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, color: Colors.blue[700], size: 16.r),
                        SizedBox(width: 8.w),
                        Text(
                          'Đã gửi lời mời kết bạn',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          label: 'Thêm bạn bè',
                          background: AppColors.primary,
                          foreground: Colors.white,
                          onTap: onAddFriend ?? () {},
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildActionButton(
                          label: 'Gỡ',
                          background: const Color(0xFFE7E7E7),
                          foreground: Colors.black,
                          onTap: onRemove ?? () {},
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMutualFriendAvatars() {
    // Nếu không có avatars hoặc không có bạn chung, return empty widget
    if (mutualFriends == 0 ||
        mutualFriendAvatars == null ||
        mutualFriendAvatars!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 48.w,
      height: 20.h,
      child: Stack(
        children: List.generate(
          mutualFriendAvatars!.length.clamp(0, 3),
          (index) => Positioned(
            left: index * 16.w,
            child: Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(mutualFriendAvatars![index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _smallAvatar(String url, {required double left}) {
    return Positioned(
      left: left,
      child: Container(
        width: 20.r,
        height: 20.r,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
