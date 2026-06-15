import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/presentation/widgets/react_widgets/react_action_button.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ReactItemWidget extends StatelessWidget {
  final ReactPostEntity react;
  final bool isSend;
  final String? requestId;
  final Function(
    String userId,
    String userAvatar,
    String? parentId,
    String userDisplayName,
  )?
  onMention;
  const ReactItemWidget({
    super.key,
    required this.react,
    required this.isSend,
    this.requestId,
    this.onMention,
  });

  Future<void> _navigateToProfile(BuildContext context) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    if (context.mounted) {
      if (currentUserId == react.user.userId) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) =>
                  di.s1<ProfileBloc>()..add(const LoadUserProfileEvent()),
              child: ProfilePage(),
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) =>
                  di.s1<OtherProfileBloc>()
                    ..add(LoadOtherUserProfileEvent(userId: react.user.userId)),
              child: OtherProfilePage(userId: react.user.userId),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bool showMutualFriends = (react.mutualFriendsCount ?? 0) > 0;
    final displayName =
        react.user.fullName ?? react.user.username ?? l10n.commonUnknown;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.rsh(context)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _navigateToProfile(context),
              child: Row(
                children: [
                  // Avatar với emoji
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 22.rsr(context),
                        backgroundImage: NetworkImage(
                          react.user.avatarUrl ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
                        ),

                        backgroundColor: AppColors.background,

                        child: react.user.avatarUrl == null
                            ? Icon(
                                Icons.person,
                                color: AppColors.textSecondary,
                                size: 22.rsp(context),
                              )
                            : null,
                      ),

                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 20.rs(context),
                          height: 20.rsh(context),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.background,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              react.emoji.icon,
                              style: TextStyle(fontSize: 12.rsp(context)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 12.rs(context)),

                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: showMutualFriends
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.rsp(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        if (showMutualFriends) ...[
                          SizedBox(height: 2.rsh(context)),
                          Text(
                            l10n.postMutualFriends(
                              react.mutualFriendsCount ?? 0,
                            ),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14.rsp(context),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action button (Thêm bạn bè/Nhắc đến)
          if (showMutualFriends || react.isFriend == true) ...[
            SizedBox(width: 8.rs(context)),
            ReactActionButton(
              userId: react.user.userId,
              isFriend: react.isFriend,
              isSend: isSend,
              requestId: requestId,
              onMention: onMention,
              userDisplayName: displayName,
              userAvatar:
                  react.user.avatarUrl ??
                  'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
            ),
          ],
        ],
      ),
    );
  }
}
