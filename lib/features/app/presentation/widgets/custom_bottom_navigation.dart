import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final int unreadCount;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.unreadCount = 0,
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
          _buildNotificationNavItem(CupertinoIcons.bell, 3),
          _buildNavItem(CupertinoIcons.line_horizontal_3, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isActive = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 28,
            color: isActive ? AppColors.primary : AppColors.unselectedIcon,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationNavItem(IconData icon, int index) {
    final isActive = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 28,
                color: isActive ? AppColors.primary : AppColors.unselectedIcon,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: -8,
                  top: -4,
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 220, 53, 69),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 18.r,
                      minHeight: 18.r,
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
