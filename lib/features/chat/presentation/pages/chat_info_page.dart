import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class ChatInfoPage extends StatelessWidget {
  final UserEntity? userInfo;
  const ChatInfoPage({super.key, this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),

            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        backgroundImage: NetworkImage(
                          userInfo?.avatarUrl ?? "https://i.pravatar.cc/200",
                        ),
                      ),

                      // Badge trạng thái hoạt động
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.background,
                              width: 2,
                            ),
                          ),

                          child: Text(
                            "26 phút",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    userInfo?.fullName ?? userInfo?.username ?? "Unknown User",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActionBtn(
                  icon: CupertinoIcons.phone_fill,
                  label: "Gọi thoại",
                ),
                _buildActionBtn(
                  icon: CupertinoIcons.videocam_fill,
                  label: "Gọi video",
                ),
                _buildActionBtn(
                  icon: CupertinoIcons.person_fill,
                  label: "Trang cá nhân",
                  size: 22.sp,
                ),
                _buildActionBtn(
                  icon: CupertinoIcons.bell_fill,
                  label: "Tắt thông báo",
                  size: 20.sp,
                ),
              ],
            ),

            SizedBox(height: 20.h),
            Divider(thickness: 8.h, color: AppColors.divider.withOpacity(0.1)),

            // SECTION: TÙY CHỈNH
            _buildSectionTitle("Tùy chỉnh"),
            _buildListTile(
              iconWidget: _buildCircleIcon(Colors.orange, isGradient: true),
              title: "Chủ đề",
              onTap: () {},
            ),

            _buildListTile(
              iconWidget: Icon(
                Icons.text_fields,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Biệt danh",
              onTap: () {},
            ),

            SizedBox(height: 10.h),
            Divider(
              height: 1,
              color: AppColors.divider,
              indent: 16.w,
              endIndent: 16.w,
            ),

            // SECTION: HÀNH ĐỘNG KHÁC
            _buildSectionTitle("Hành động khác"),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.person_2_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Tạo nhóm chat",
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.photo,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Xem file phương tiện, file và liên kết",
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.pin_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Tin nhắn đã ghim",
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.search,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Tìm kiếm trong cuộc trò chuyện",
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.share,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Chia sẻ thông tin liên hệ",
              onTap: () {},
            ),

            SizedBox(height: 10.h),
            Divider(
              height: 1,
              color: Colors.grey.shade200,
              indent: 16.w,
              endIndent: 16.w,
            ),

            // SECTION: QUYỀN RIÊNG TƯ & HỖ TRỢ
            _buildSectionTitle("Quyền riêng tư & Hỗ trợ"),

            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.eye_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Thông báo đã đọc",
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.chat_bubble_text_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Chỉ báo đang nhập",
              subtitle: "Đang bật",
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.nosign,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Hạn chế",
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.minus_circle_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Chặn",
              onTap: () {},
            ),
            _buildListTile(
              iconWidget: Icon(
                CupertinoIcons.exclamationmark_triangle_fill,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
              title: "Báo cáo",
              subtitle: "Góp ý và báo cáo cuộc trò chuyện",
              onTap: () {},
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.6),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    double size = 24,
  }) {
    return Column(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: size.sp),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 70.w, // Giới hạn chiều rộng để text tự xuống dòng nếu dài
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required Widget iconWidget,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 30.w,
              height: 30.w,
              child: Center(child: iconWidget),
            ),

            SizedBox(width: 14.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  // Nếu có subtitle thì mới render
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget vẽ hình tròn icon "Chủ đề"
  Widget _buildCircleIcon(Color color, {bool isGradient = false}) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isGradient ? null : color,
        gradient: isGradient
            ? LinearGradient(
                colors: [color, color.withOpacity(0.5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Center(
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
