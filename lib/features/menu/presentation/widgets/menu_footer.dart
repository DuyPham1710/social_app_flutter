import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/app/presentation/widgets/restart_widget.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';

class MenuFooter extends StatelessWidget {
  const MenuFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Trợ giúp và hỗ trợ'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Cài đặt và quyền riêng tư'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Đăng xuất'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppColors.background,
                  title: Text(
                    "Đăng xuất khỏi tài khoản của bạn?",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // đóng dialog
                      },
                      child: const Text(
                        "Hủy",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // đóng dialog

                        // Dispatch event logout
                        context.read<MenuBloc>().add(LogoutEvent());

                        RestartWidget.restartApp(context);

                        // Điều hướng về login
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Đăng xuất",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
