import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/config/theme/app_theme.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/login_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/otp_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/personal_info_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/register_page.dart';
import 'package:social_app_fe/features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  final authBloc = s1<AuthBloc>();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider.value(value: authBloc)],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Namer App',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: LoginPage(),
          routes: <String, WidgetBuilder>{
            '/login': (BuildContext context) => const LoginPage(),
            '/home': (BuildContext context) => const HomePage(),
            '/signup': (BuildContext context) => const RegisterPage(),
            '/forgot-password': (BuildContext context) =>
                const ForgotPasswordPage(),
            '/otp': (BuildContext context) => const OtpPage(),
            '/personal-info': (BuildContext context) =>
                const PersonalInfoPage(),
          },
        );
      },
    );
  }
}
