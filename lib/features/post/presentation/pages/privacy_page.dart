import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPage extends StatefulWidget {
  final String selectedOption;
  const PrivacyPage({super.key, required this.selectedOption});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late String selected;

  final List<Map<String, String>> options = [
    {'label': 'Công khai', 'desc': 'Bất kỳ ai ở trên hoặc ngoài App'},
    {'label': 'Bạn bè', 'desc': 'Bạn bè của bạn trên App'},
    {'label': 'Bạn bè ngoại trừ...', 'desc': 'Ẩn bài viết khỏi một số bạn bè'},
    {'label': 'Bạn bè cụ thể', 'desc': 'Chỉ hiển thị với một vài bạn'},
    {'label': 'Chỉ mình tôi', 'desc': 'Chỉ mình tôi'},
    {'label': 'Bạn thân', 'desc': 'Danh sách tùy chỉnh của bạn'},
    {'label': 'Người quen', 'desc': 'Danh sách tùy chỉnh của bạn'},
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: AppColors.textSecondary,
          ),
        ),

        middle: Text('Ai có thể xem bài viết của bạn?'),

        trailing: GestureDetector(
          onTap: () => Navigator.pop(context, selected),
          child: Text(
            'Xong',
            style: TextStyle(
              color: CupertinoColors.activeBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      child: SafeArea(
        child: Material(
          color: AppColors.background,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text(
                'Bài viết của bạn sẽ hiển thị trên Bảng feed, trang cá nhân và trong kết quả tìm kiếm.\n\n'
                'Tùy đối tượng mặc định là ${widget.selectedOption}, nhưng bạn có thể thay đổi đối tượng của riêng bài viết này.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),

              SizedBox(height: 16.h),

              ...options.map((item) {
                final isSelected = selected == item['label'];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  leading: Icon(
                    _getIcon(item['label']!),
                    color: AppColors.textPrimary,
                  ),

                  title: Text(
                    item['label']!,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  subtitle: Text(
                    item['desc']!,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                  ),

                  trailing: Icon(
                    isSelected
                        ? CupertinoIcons.check_mark_circled_solid
                        : CupertinoIcons.circle,
                    color: isSelected
                        ? CupertinoColors.activeBlue
                        : Colors.grey,
                  ),

                  onTap: () => setState(() => selected = item['label']!),
                );
              }),

              SizedBox(height: 12.h),

              Row(
                children: [
                  CupertinoSwitch(value: true, onChanged: (_) {}),

                  SizedBox(width: 8.w),

                  Text(
                    'Đặt làm đối tượng mặc định',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String label) {
    switch (label) {
      case 'Công khai':
        return CupertinoIcons.globe;
      case 'Bạn bè':
        return CupertinoIcons.person_2_fill;
      case 'Bạn bè ngoại trừ...':
        return CupertinoIcons.person_crop_circle_badge_minus;
      case 'Bạn bè cụ thể':
        return CupertinoIcons.person_crop_circle_badge_checkmark;
      case 'Chỉ mình tôi':
        return CupertinoIcons.lock_fill;
      case 'Bạn thân':
        return CupertinoIcons.star_fill;
      case 'Người quen':
        return CupertinoIcons.person_crop_circle_badge_exclam;
      default:
        return CupertinoIcons.person;
    }
  }
}
