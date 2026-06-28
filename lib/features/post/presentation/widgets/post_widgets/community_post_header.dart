import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/community/domain/entities/community_entity.dart';
import 'package:social_app_fe/features/community/presentation/pages/community_detail_page.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:social_app_fe/features/post/presentation/utils/post_time_formatter.dart';
import 'package:social_app_fe/shared/widgets/custom_popup_menu_button.dart';
import 'package:social_app_fe/l10n/l10n.dart';

/// Community Post Header
/// Shows: Community Badge > Community Name + Avatar | User Name | Time
/// Used for posts within communities (always public by default)
class CommunityPostHeader extends StatelessWidget {
  final CommunityEntity? community;
  final UserEntity user;
  final DateTime? createdAt;
  final VoidCallback? onOptionsTap;
  final VoidCallback? onReportTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onSaveTap;
  final bool isSaved;
  final bool showCommunityInfo; // Ẩn info nhóm khi xem trong community detail
  final String? communityUserRole;
  final String? location;

  const CommunityPostHeader({
    super.key,
    required this.community,
    required this.user,
    this.createdAt,
    this.onOptionsTap,
    this.onReportTap,
    this.onShareTap,
    this.onSaveTap,
    this.isSaved = false,
    this.showCommunityInfo = true, // Default: hiển thị info nhóm
    this.communityUserRole,
    this.location,
  });

  Future<void> _navigateToCommunity(BuildContext context) async {
    if (community == null) return;
    Navigator.push(
      context,
      CommunityDetailPage.route(communityId: community!.id),
    );
  }

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
        vertical: 8.rsh(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Community Avatar (large with border) + Community Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Community Avatar with User Avatar overlay (chỉ hiển thị nếu showCommunityInfo = true)
              if (community != null && showCommunityInfo)
                GestureDetector(
                  onTap: () => _navigateToCommunity(context),
                  child: Stack(
                    children: [
                      // Large Community Avatar with border
                      Container(
                        width: 60.rs(context),
                        height: 60.rs(context),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.divider,
                            width: 1.5.rs(context),
                          ),
                          borderRadius: BorderRadius.circular(8.rsr(context)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2.rsh(context)),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.rsr(context)),
                          child: community!.avatar != null
                              ? Image.network(
                                  community!.avatar,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.group,
                                      size: 24.rsp(context),
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      // User Avatar overlay (bottom-right, 50% border)
                      Positioned(
                        bottom: -6.rsh(context),
                        right: -6.rsh(context),
                        child: GestureDetector(
                          onTap: () => _navigateToProfile(context),
                          child: Container(
                            width: 36.rs(context),
                            height: 36.rs(context),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.background,
                                width: 2.5.rs(context),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                  offset: Offset(0, 2.rsh(context)),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                user.avatarUrl ??
                                    "https://randomuser.me/api/portraits/men/1.jpg",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (showCommunityInfo) SizedBox(width: 12.rs(context)),
              // Community Name + User Info (chỉ hiển thị community name nếu showCommunityInfo = true)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showCommunityInfo) ...[
                      SizedBox(height: 4.rsh(context)),
                      // Community Name
                      GestureDetector(
                        onTap: () => _navigateToCommunity(context),
                        child: Text(
                          community?.name ?? context.l10n.menuCommunity,
                          style: TextStyle(
                            fontSize: 15.rsp(context),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.rsh(context)),
                    ] else
                      SizedBox(height: 4.rsh(context)),
                    // User Name
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _navigateToProfile(context),
                          child: Text(
                            user.fullName ??
                                user.username ??
                                context.l10n.commonUnknown,
                            style: TextStyle(
                              fontSize: 11.rsp(context),
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (location != null && location!.isNotEmpty) ...[
                          SizedBox(width: 4.rs(context)),
                          Text(
                            context.l10n.postAtLocation,
                            style: TextStyle(
                              fontSize: 11.rsp(context),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 4.rs(context)),
                          Text(
                            location!,
                            style: TextStyle(
                              fontSize: 11.rsp(context),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(width: 4.rs(context)),
                        Text(
                          '·',
                          style: TextStyle(
                            fontSize: 11.rsp(context),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: 4.rs(context)),
                        Icon(
                          Icons.groups_rounded,
                          size: 14.rsp(context),
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.rsh(context)),
                    // Time · Visibility
                    Row(
                      children: [
                        Text(
                          localizedPostTime(context.l10n, createdAt),
                          style: TextStyle(
                            fontSize: 11.rsp(context),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _StableCurrentUserBuilder(
                builder: (context, currentUserId) {
                  if (currentUserId == null) return const SizedBox.shrink();

                  final isOwner = currentUserId == user.userId;
                  final isCommunityAdmin =
                      communityUserRole == 'admin' ||
                      community?.admin.userId == currentUserId;
                  final canDelete =
                      onOptionsTap != null &&
                      (isOwner || (isCommunityAdmin && !isOwner));
                  final canSave = onSaveTap != null && !isOwner;
                  final canReport =
                      onReportTap != null && !isOwner && !isCommunityAdmin;

                  if (!canDelete && !canSave && !canReport && onShareTap == null) {
                    return const SizedBox.shrink();
                  }

                  return CustomPopupMenuButton<String>(
                    color: AppColors.background,
                    onSelected: (value) {
                      if (value == 'delete') {
                        onOptionsTap?.call();
                      } else if (value == 'save') {
                        onSaveTap?.call();
                      } else if (value == 'report') {
                        onReportTap?.call();
                      } else if (value == 'share') {
                        onShareTap?.call();
                      }
                    },
                    itemBuilder: (BuildContext popupContext) => [
                      if (onShareTap != null)
                        PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(
                                Icons.share,
                                size: 18.rsp(context),
                                color: AppColors.iconPrimary,
                              ),
                              SizedBox(width: 8.rs(context)),
                              Text(context.l10n.postShare),
                            ],
                          ),
                        ),
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
                                color: Colors.red,
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
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.textSecondary,
                      size: 18.rsp(context),
                    ),
                  );
                },
              ),
            ],
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
