import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';

class MenuHeader extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const MenuHeader({super.key, required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
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
