import 'package:flutter/cupertino.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.unselectedIcon.withOpacity(0.1),
            offset: const Offset(0, -1),
            blurRadius: 4.r,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(CupertinoIcons.house_fill, 0),
          _buildNavItem(CupertinoIcons.person_2, 1),
          _buildNavItem(CupertinoIcons.plus_app, 2),
          _buildNavItem(CupertinoIcons.bell, 3),
          _buildNavItem(CupertinoIcons.line_horizontal_3, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Icon(
        icon,
        size: 28,
        color: isActive ? AppColors.primary : AppColors.unselectedIcon,
      ),
    );
  }
}
