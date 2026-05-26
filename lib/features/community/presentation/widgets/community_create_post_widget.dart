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
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withValues(alpha: 0.08),
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
                backgroundColor: AppColors.secondBackground,
                backgroundImage: currentAvatarUrl != null
                    ? NetworkImage(currentAvatarUrl)
                    : null,
                child: currentAvatarUrl == null
                    ? Icon(Icons.person, color: AppColors.textSecondary)
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
                  color: AppColors.secondBackground,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.divider),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.communityWritePostHint,
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.photo_library_outlined, color: AppColors.primary),
            onPressed: onCreatePost,
          ),
        ],
      ),
    );
  }
}
