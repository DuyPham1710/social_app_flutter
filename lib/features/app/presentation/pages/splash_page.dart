import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_event.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final user = await TokenStorage.getUserData();
    final token = await TokenStorage.getAccessToken();

    await Future.delayed(
      const Duration(seconds: 2),
    ); // Chờ 2 giây để hiển thị logo

    if (!mounted) return;

    if (user != null && token != null) {
      // Load user hiện tại vào MenuBloc
      context.read<MenuBloc>().add(LoadCurrentUserEvent());

      // Chuyển vào main
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Không có session → vào login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/icons/logo.jpg',
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
