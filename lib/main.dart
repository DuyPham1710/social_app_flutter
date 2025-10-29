import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/config/theme/app_theme.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/app/presentation/pages/main_page.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/login_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/otp_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/personal_info_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/register_page.dart';
import 'package:social_app_fe/features/auth/presentation/pages/reset_password_page.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/home/presentation/pages/home_page.dart';
import 'package:social_app_fe/features/story/presentation/bloc/home_stories_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  print('BASE_URL: ${dotenv.env['BASE_URL']}');
  await initializeDependencies();

  final authBloc = s1<AuthBloc>();
  final homeBloc = s1<HomeBloc>();
  final friendBloc = s1<FriendBloc>();
  final homeStoriesBloc = s1<HomeStoriesBloc>();
  final menuBloc = s1<MenuBloc>();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: homeBloc),
        BlocProvider.value(value: friendBloc),
        BlocProvider.value(value: homeStoriesBloc),
        BlocProvider.value(value: menuBloc),
      ],
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
          initialRoute: '/login',
          routes: <String, WidgetBuilder>{
            '/main': (BuildContext context) => const MainPage(),
            '/login': (BuildContext context) => const LoginPage(),
            '/home': (BuildContext context) => const HomePage(),
            '/signup': (BuildContext context) => const RegisterPage(),
            '/forgot-password': (BuildContext context) =>
                const ForgotPasswordPage(),
            '/otp': (BuildContext context) => const OtpPage(),
            '/personal-info': (BuildContext context) =>
                const PersonalInfoPage(),
            '/reset-password': (BuildContext context) =>
                const ResetPasswordPage(),
          },
        );
      },
    );
  }
}
