import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/services/fcm_service.dart';
import 'package:social_app_fe/features/app/presentation/widgets/restart_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';

class MenuFooter extends StatelessWidget {
  const MenuFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: AppColors.divider),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text(context.l10n.menuHelpSupport),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(context.l10n.menuSettingsPrivacy),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(context.l10n.menuLogout),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppColors.background,
                  title: Text(
                    context.l10n.menuLogoutDialogTitle,
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
                      child: Text(
                        context.l10n.commonCancel,
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),

                    TextButton(
                      onPressed: () async {
                        //Navigator.pop(context); // đóng dialog

                        // Clear FCM token trước khi đăng xuất
                        await FcmService().clearFcmToken();

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
                      child: Text(
                        context.l10n.menuLogout,
                        style: const TextStyle(color: Colors.red),
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
