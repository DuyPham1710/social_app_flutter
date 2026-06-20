import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:social_app_fe/features/post/presentation/utils/post_time_formatter.dart';
import 'package:social_app_fe/l10n/l10n.dart';

/// Community Post Header Base
/// Đơn giản như PostHeader nhưng với navigation logic của CommunityPostHeader
/// Dùng cho posts trong community detail page
class CommunityPostHeaderBase extends StatelessWidget {
  final UserEntity user;
  final DateTime? createdAt;
  final VoidCallback? onOptionsTap;
  final VoidCallback? onReportTap;
  final VoidCallback? onSaveTap;
  final bool isSaved;
  final String? communityUserRole;
  final String? location;

  const CommunityPostHeaderBase({
    super.key,
    required this.user,
    this.createdAt,
    this.onOptionsTap,
    this.onReportTap,
    this.onSaveTap,
    this.isSaved = false,
    this.communityUserRole,
    this.location,
  });

  Future<void> _navigateToProfile(BuildContext context) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    // Nếu là user hiện tại → My Profile
    if (currentUserId == user.userId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                di.s1<ProfileBloc>()..add(const LoadUserProfileEvent()),
            child: const ProfilePage(),
          ),
        ),
      );
    } else {
      // Nếu là người khác → Other Profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                di.s1<OtherProfileBloc>()
                  ..add(LoadOtherUserProfileEvent(userId: user.userId)),
            child: OtherProfilePage(userId: user.userId),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.rs(context),
        vertical: 6.rsh(context),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                user.avatarUrl ??
                    "https://randomuser.me/api/portraits/men/1.jpg",
              ),
            ),
          ),
          SizedBox(width: 10.rs(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _navigateToProfile(context),
                      child: Text(
                        user.fullName ?? context.l10n.commonUser,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.rsp(context),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (location != null && location!.isNotEmpty) ...[
                      SizedBox(width: 6.rs(context)),
                      Text(
                        context.l10n.postAtLocation,
                        style: TextStyle(
                          fontSize: 14.rsp(context),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 6.rs(context)),
                      Text(
                        location!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.rsp(context),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  localizedPostTime(context.l10n, createdAt),
                  style: TextStyle(
                    fontSize: 12.rsp(context),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _StableCurrentUserBuilder(
            builder: (context, currentUserId) {
              if (currentUserId == null) return const SizedBox.shrink();

              final isOwner = currentUserId == user.userId;
              final isCommunityAdmin = communityUserRole == 'admin';
              final canDelete =
                  onOptionsTap != null &&
                  (isOwner || (isCommunityAdmin && !isOwner));
              final canSave = onSaveTap != null && !isOwner;
              final canReport =
                  onReportTap != null && !isOwner && !isCommunityAdmin;

              if (!canDelete && !canSave && !canReport) {
                return const SizedBox.shrink();
              }

              return PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, size: 20.rsp(context)),
                color: AppColors.background,
                onSelected: (value) {
                  if (value == 'report') {
                    onReportTap?.call();
                  } else if (value == 'save') {
                    onSaveTap?.call();
                  } else if (value == 'delete') {
                    onOptionsTap?.call();
                  }
                },
                itemBuilder: (context) => [
                  if (canSave)
                    PopupMenuItem(
                      value: 'save',
                      child: Row(
                        children: [
                          Icon(
                            isSaved
                                ? Icons.bookmark_remove_outlined
                                : Icons.bookmark_border_rounded,
                            size: 18.rsp(context),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 8.rs(context)),
                          Text(
                            isSaved
                                ? context.l10n.postUnsave
                                : context.l10n.postSave,
                          ),
                        ],
                      ),
                    ),
                  if (canReport)
                    PopupMenuItem(
                      value: 'report',
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            size: 18.rsp(context),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 8.rs(context)),
                          Text(context.l10n.postReport),
                        ],
                      ),
                    ),
                  if (canDelete)
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18.rsp(context),
                            color: Colors.red,
                          ),
                          SizedBox(width: 8.rs(context)),
                          Text(
                            context.l10n.postDeleteTitle,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StableCurrentUserBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, String? currentUserId) builder;

  const _StableCurrentUserBuilder({required this.builder});

  @override
  State<_StableCurrentUserBuilder> createState() =>
      _StableCurrentUserBuilderState();
}

class _StableCurrentUserBuilderState extends State<_StableCurrentUserBuilder> {
  late final Future<String?> _currentUserIdFuture;

  @override
  void initState() {
    super.initState();
    _currentUserIdFuture = TokenStorage.getUserData().then(
      (userData) => userData?['id']?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _currentUserIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        return widget.builder(context, snapshot.data);
      },
    );
  }
}
