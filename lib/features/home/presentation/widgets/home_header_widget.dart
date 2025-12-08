import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_list_page.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_event.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.all(16.0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Home',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(
                  CupertinoIcons.search,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
              SizedBox(width: 8.w),
              BlocProvider<MenuBloc>(
                create: (_) => s1<MenuBloc>()..add(LoadCurrentUserEvent()),
                child: IconButton(
                  icon: const Icon(
                    CupertinoIcons.chat_bubble_2,
                    color: AppColors.primary,
                  ),

                  // bọc trong blocProvider để sử dụng   create: (_) => s1<MenuBloc>()..add(LoadCurrentUserEvent()),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const ChatListPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
