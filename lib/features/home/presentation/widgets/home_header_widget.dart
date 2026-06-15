import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_list_page.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_event.dart';

class HomeHeaderWidget extends StatelessWidget {
  /// If true, renders a desktop-friendly header
  /// (no logo text since it's in the sidebar, only action buttons).
  final bool isDesktop;

  const HomeHeaderWidget({super.key, this.isDesktop = false});

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return _buildDesktopHeader(context);
    }
    return _buildMobileHeader(context);
  }

  /// Mobile header: logo + search + chat icons
  Widget _buildMobileHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 8.h),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 16.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CommonsHub',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  _buildGlassIconButton(
                    icon: CupertinoIcons.search,
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                  SizedBox(width: 8.w),
                  BlocProvider<MenuBloc>(
                    create: (_) => s1<MenuBloc>()..add(LoadCurrentUserEvent()),
                    child: _buildGlassIconButton(
                      icon: CupertinoIcons.chat_bubble_2,
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ChatListPage(),
                          ),
                        );
                      },
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

  /// Desktop header: simplified, no logo (it's in sidebar).
  /// Shows only the "CommonsHub" feed title or nothing.
  Widget _buildDesktopHeader(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CommonsHub',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          // No action buttons here; they're in the sidebar
        ],
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.unselectedIcon.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.divider, width: 0.5),
            ),
            child: Center(
              child: Icon(icon, color: AppColors.primary, size: 22.sp),
            ),
          ),
        ),
      ),
    );
  }
}
