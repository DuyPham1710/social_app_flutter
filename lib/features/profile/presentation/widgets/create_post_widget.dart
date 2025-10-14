import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class CreatePostWidget extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback? onCreatePost;

  const CreatePostWidget({super.key, this.avatarUrl, this.onCreatePost});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : const AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onCreatePost,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.textSecondary),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  "Bạn đang nghĩ gì?",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.photo_library_outlined,
              color: const Color.fromARGB(255, 9, 219, 121),
            ),
            onPressed: onCreatePost,
          ),
        ],
      ),
    );
  }
}
