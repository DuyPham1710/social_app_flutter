import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_state.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityCreatePostWidget extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback? onCreatePost;

  const CommunityCreatePostWidget({
    super.key,
    this.avatarUrl,
    this.onCreatePost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          BlocBuilder<MenuBloc, MenuState>(
            builder: (context, state) {
              final currentAvatarUrl = state is MenuLoadedState
                  ? state.user.avatarUrl
                  : avatarUrl;

              return CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFE4E6EB),
                backgroundImage: currentAvatarUrl != null
                    ? NetworkImage(currentAvatarUrl)
                    : null,
                child: currentAvatarUrl == null
                    ? const Icon(Icons.person, color: Color(0xFF65676B))
                    : null,
              );
            },
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
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFDADDE1)),
                ),
                child: Text(
                  context.l10n.communityWritePostHint,
                  style: const TextStyle(
                    color: Color(0xFF65676B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.photo_library_outlined,
              color: Color(0xFF1877F2),
            ),
            onPressed: onCreatePost,
          ),
        ],
      ),
    );
  }
}
