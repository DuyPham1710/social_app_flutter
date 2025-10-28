import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';

import '../../../post/domain/usecases/get_profile_posts_usecase.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';

class MenuHeader extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String userId;

  const MenuHeader({super.key, required this.name, required this.avatarUrl, required this.userId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ProfileBloc(
                getProfilePostsUseCase: context.read<GetProfilePostsUseCase>(),
              ),
              child: ProfilePage(userId: userId),
            ),
          ),
        );
      },
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tạo trang cá nhân hoặc Trang mới',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.add_circle_outline, color: Colors.black54),
        ],
      ),
    );
  }
}
