import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

class ChatSearchPage extends StatefulWidget {
  const ChatSearchPage({super.key});

  @override
  State<ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> {
  final TextEditingController _controller = TextEditingController();

  final List<String> recentSearch = ["Tài Nguy...", "Khang", "Nhungg"];

  final List<String> suggestions = [
    "Hồngg Nhung",
    "Hồng Đào",
    "Thảo Vy",
    "Nguyễn Khang",
    "Ân Ân",
    "Hoàng Thông",
    "Bạch Tuyết",
    "Duy Phạm",
    "Hồngg Nhung",
    "Hồng Đào",
    "Thảo Vy",
    "Nguyễn Khang",
    "Ân Ân",
    "Hoàng Thông",
    "Bạch Tuyết",
    "Duy Phạm",
    "Hồngg Nhung",
    "Hồng Đào",
    "Thảo Vy",
    "Nguyễn Khang",
    "Ân Ân",
    "Hoàng Thông",
    "Bạch Tuyết",
    "Duy Phạm",
    "Hồngg Nhung",
    "Hồng Đào",
    "Thảo Vy",
    "Nguyễn Khang",
    "Ân Ân",
    "Hoàng Thông",
    "Bạch Tuyết",
    "Duy Phạm",
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 0.9.sh,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 40.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      controller: _controller,
                      placeholder: "Tìm kiếm",
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      "Huỷ",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            Expanded(
              child: _controller.text.isEmpty
                  ? _buildSearchContent()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        SizedBox(height: 10.h),
        Text(
          "Tìm kiếm gần đây",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),

        Wrap(
          spacing: 12.w,
          children: recentSearch.map((e) => _buildCircleUser(e)).toList(),
        ),

        SizedBox(height: 20.h),
        Text(
          "Gợi ý",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),

        Column(children: suggestions.map((e) => _buildUserTile(e)).toList()),
      ],
    );
  }

  Widget _buildSearchResults() {
    final results = suggestions
        .where((e) => e.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          "Không tìm thấy kết quả",
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: results.map((e) => _buildUserTile(e)).toList(),
    );
  }

  Widget _buildCircleUser(String name) {
    return Column(
      children: [
        CircleAvatar(radius: 25.r, backgroundColor: Colors.grey.shade300),
        SizedBox(height: 6.h),
        Text(name, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildUserTile(String name) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 22.r,
        backgroundColor: Colors.grey.shade300,
      ),
      title: Text(
        name,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
      ),
      onTap: () {
        // TODO: xử lý khi click vào user
      },
    );
  }
}
