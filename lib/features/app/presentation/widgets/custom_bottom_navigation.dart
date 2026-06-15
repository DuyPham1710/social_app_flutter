import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final int unreadCount;
  final String avt;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.unreadCount = 0,
    required this.avt,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.rs(context),
          right: 24.rs(context),
          bottom: 20.rsh(context),
        ),
        child: SizedBox(
          height: 80.rsh(context),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _buildBarBackground(
                context,
                child: Row(
                  children: [
                    _buildTabItem(
                      context,
                      index: 0,
                      icon: CupertinoIcons.house_fill,
                    ),
                    _buildTabItem(
                      context,
                      index: 1,
                      icon: CupertinoIcons.person_2,
                    ),
                    Expanded(child: SizedBox()),
                    _buildNotificationTabItem(
                      context,
                      index: 3,
                      icon: CupertinoIcons.bell,
                    ),
                    _buildInfoTabItem(context, index: 4, avt: avt),
                  ],
                ),
              ),
              Positioned(
                bottom: 16.rsh(context),
                child: _buildCenterActionButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarBackground(BuildContext context, {required Widget child}) {
    return Container(
      height: 64.rsh(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.rsr(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24.rsr(context),
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(32.rsr(context)),
        ),
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required int index,
    required IconData icon,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.unselectedIcon;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.rsh(context)),
          child: Icon(icon, size: 26.rsp(context), color: color),
        ),
      ),
    );
  }

  Widget _buildInfoTabItem(
    BuildContext context, {
    required int index,
    required String avt,
  }) {
    final isActive = currentIndex == index;

    final color = isActive ? AppColors.primary : AppColors.unselectedIcon;
    final hasAvatar = avt.isNotEmpty;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Center(
          child: Container(
            width: 32.rs(context),
            height: 32.rs(context),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: hasAvatar
                    ? Image.network(
                        avt,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person, color: color);
                        },
                      )
                    : Icon(Icons.person, color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTabItem(
    BuildContext context, {
    required int index,
    required IconData icon,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.unselectedIcon;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.rsh(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 26.rsp(context), color: color),
                  if (unreadCount > 0)
                    Positioned(
                      right: -10.rs(context),
                      top: -6.rsh(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.rs(context),
                          vertical: 2.rsh(context),
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 220, 53, 69),
                          borderRadius: BorderRadius.circular(10.rsr(context)),
                        ),
                        constraints: BoxConstraints(minWidth: 18.rs(context)),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.rsp(context),
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

  Widget _buildCenterActionButton(context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.rsr(context)),
        onTap: () => onTabSelected(2),
        child: Ink(
          width: 56.rs(context),
          height: 56.rs(context),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20.rsr(context)),
          ),
          child: Icon(
            CupertinoIcons.plus,
            color: Colors.white,
            size: 30.rsp(context),
          ),
        ),
      ),
    );
  }
}
