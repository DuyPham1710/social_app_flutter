import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_state.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityCreatePostWidget extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback? onCreatePost;

  CommunityCreatePostWidget({super.key, this.avatarUrl, this.onCreatePost});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 12.rs(context),
        vertical: 8.rsh(context),
      ),
      padding: EdgeInsets.all(8.rs(context)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.rsr(context)),
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
                radius: 22.rsr(context),
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
          SizedBox(width: 10.rs(context)),
          Expanded(
            child: GestureDetector(
              onTap: onCreatePost,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.rs(context),
                  vertical: 10.rsh(context),
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondBackground,
                  borderRadius: BorderRadius.circular(999.rsr(context)),
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
                      fontSize: 14.rsp(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.rs(context)),
          IconButton(
            icon: Icon(Icons.photo_library_outlined, color: AppColors.primary),
            onPressed: onCreatePost,
          ),
        ],
      ),
    );
  }
}
