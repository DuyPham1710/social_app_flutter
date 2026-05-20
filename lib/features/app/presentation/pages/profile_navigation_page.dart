import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';

class ProfileNavigationPage extends StatelessWidget {
  const ProfileNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => di.s1<ProfileBloc>()..add(const LoadUserProfileEvent()),
      child: ProfilePage(),
    );
  }
}
