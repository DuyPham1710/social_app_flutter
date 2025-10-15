import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class FriendRequestItem extends StatelessWidget {
  final String name;
  final int mutualFriends;
  final String timeAgo;
  final String avatarUrl;
  final List<String>? mutualFriendAvatars;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final bool isAccepted;
  final bool isRejected;

  const FriendRequestItem({
    super.key,
    required this.name,
    required this.mutualFriends,
    required this.timeAgo,
    required this.avatarUrl,
    this.mutualFriendAvatars,
    this.onAccept,
    this.onReject,
    this.isAccepted = false,
    this.isRejected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar lớn hơn như trong hình
          CircleAvatar(
            radius: 32.r,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên người dùng và thời gian
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Bạn chung với avatars - chỉ hiển thị khi có bạn chung
                if (mutualFriends > 0)
                  Row(
                    children: [
                      if (mutualFriendAvatars != null && mutualFriendAvatars!.isNotEmpty)
                        _buildMutualFriendAvatars()
                      else
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Icon(
                            CupertinoIcons.person_2,
                            size: 14.r,
                            color: Colors.blue[600],
                          ),
                        ),
                      SizedBox(width: 6.w),
                      Text(
                        '$mutualFriends bạn chung',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16.h),
                // Nút hành động hoặc thông báo
                if (isAccepted)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.green[200]!, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[700],
                          size: 16.r,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Các bạn đã trở thành bạn bè',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (isRejected)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.grey[700],
                          size: 16.r,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Đã gỡ lời mời',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          label: 'Chấp nhận',
                          background: AppColors.primary,
                          foreground: Colors.white,
                          onTap: onAccept ?? () {},
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildActionButton(
                          label: 'Xóa',
                          background: const Color(0xFFE7E7E7),
                          foreground: Colors.black,
                          onTap: onReject ?? () {},
                        ),
                      ),
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMutualFriendAvatars() {
    // Nếu không có avatars hoặc không có bạn chung, return empty widget
    if (mutualFriends == 0 || mutualFriendAvatars == null || mutualFriendAvatars!.isEmpty) {
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



