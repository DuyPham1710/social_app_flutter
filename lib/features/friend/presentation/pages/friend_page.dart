import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_header_chips.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_request_item.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_suggestion_item.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.search),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FriendHeaderChips(),
              SizedBox(height: 16.h),

              // Lời mời kết bạn
              _buildSectionHeader(
                title: 'Lời mời kết bạn',
                trailing: 'Xem tất cả',
                onTapTrailing: () {},
              ),
              SizedBox(height: 8.h),
              Container(
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
                child: Column(
                  children: List.generate(
                    1,
                    (index) => const FriendRequestItem(
                      name: 'Nguyễn Văn Luân',
                      mutualFriends: 20,
                      timeAgo: '2 ngày trước',
                      avatarUrl:
                          'https://i.pravatar.cc/150?img=12',
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Những người bạn có thể biết
              _buildSectionHeader(
                title: 'Những người bạn có thể biết',
              ),
              SizedBox(height: 8.h),
              Column(
                children: List.generate(
                  5,
                  (index) => FriendSuggestionItem(
                    name: 'Nguyễn Văn Luân',
                    mutualFriends: 20,
                    avatarUrl: 'https://i.pravatar.cc/150?img=${index + 30}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? trailing,
    VoidCallback? onTapTrailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTapTrailing,
            child: Text(
              trailing,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}



