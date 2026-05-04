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
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 10.h),
        child: SizedBox(
          height: 76.h,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _buildBarBackground(
                child: Row(
                  children: [
                    _buildTabItem(index: 0, icon: CupertinoIcons.house_fill),
                    _buildTabItem(index: 1, icon: CupertinoIcons.person_2),
                    SizedBox(width: 70.w),
                    _buildNotificationTabItem(
                      index: 3,
                      icon: CupertinoIcons.bell,
                    ),
                    _buildTabItem(
                      index: 4,
                      icon: CupertinoIcons.line_horizontal_3,
                    ),
                  ],
                ),
              ),
              Positioned(bottom: 14.h, child: _buildCenterActionButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarBackground({required Widget child}) {
    return Container(
      height: 62.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }

  Widget _buildTabItem({required int index, required IconData icon}) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.unselectedIcon;

    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Icon(icon, size: 26.sp, color: color),
        ),
      ),
    );
  }

  Widget _buildNotificationTabItem({
    required int index,
    required IconData icon,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.unselectedIcon;

    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 26.sp, color: color),
                  if (unreadCount > 0)
                    Positioned(
                      right: -10.w,
                      top: -6.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 220, 53, 69),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        constraints: BoxConstraints(minWidth: 18.w),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterActionButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () => onTabSelected(2),
        child: Ink(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Icon(CupertinoIcons.plus, color: Colors.white, size: 30.sp),
        ),
      ),
    );
  }
}
