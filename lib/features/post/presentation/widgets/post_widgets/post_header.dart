import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/post/presentation/helpers/tag_helper.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:social_app_fe/features/post/presentation/utils/post_time_formatter.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class PostHeader extends StatelessWidget {
  final UserEntity user;
  final DateTime? createdAt;
  final VoidCallback? onReportTap;
  final VoidCallback? onOptionsTap;
  final VoidCallback? onSaveTap;
  final bool? isSaved;
  final List<UserEntity>? taggedUsers;
  final List<String>? visibleOnProfileUserIds;
  final Function(bool)? onTagVisibilityTap;
  final VoidCallback? onRemoveTagTap;

  const PostHeader({
    super.key,
    required this.user,
    this.createdAt,
    this.onReportTap,
    this.onOptionsTap,
    this.onSaveTap,
    this.isSaved,
    this.taggedUsers,
    this.visibleOnProfileUserIds,
    this.onTagVisibilityTap,
    this.onRemoveTagTap,
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
      //Nếu là người khác → Other Profile
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

  Widget _buildTitleText(BuildContext context) {
    final l10n = context.l10n;
    final ownerName = user.fullName ?? l10n.commonUser;
    final taggedNames =
        taggedUsers?.map((u) => u.fullName ?? l10n.commonUser).toList() ?? [];

    return TagHelper.buildTitleWithTags(
      l10n: l10n,
      ownerName: ownerName,
      taggedNames: taggedNames,
      boldStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.rsp(context),
        color: AppColors.textPrimary,
      ),
      normalStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14.rsp(context),
        color: AppColors.textSecondary,
      ),
    );
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
                GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: _buildTitleText(context),
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
              final isOwner = currentUserId == user.userId;

              if (isOwner) {
                // Nếu là chủ sở hữu, hiển thị icon để mở options
                return IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    size: 20.rsp(context),
                    color: AppColors.iconPrimary,
                  ),
                  onPressed: onOptionsTap,
                );
              } else {
                // Nếu không phải chủ sở hữu, hiển thị menu report/share
                return PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    size: 20.rsp(context),
                    color: AppColors.iconPrimary,
                  ),
                  color: AppColors.background,
                  surfaceTintColor: Colors.transparent,
                  onSelected: (value) async {
                    if (value == 'report') {
                      onReportTap?.call();
                    } else if (value == 'share') {
                      // TODO: Thêm logic chia sẻ bài viết nếu cần
                    } else if (value == 'save') {
                      onSaveTap?.call();
                    } else if (value == 'toggle_tag_visibility') {
                      final isVisible =
                          visibleOnProfileUserIds?.contains(currentUserId) ??
                          false;
                      onTagVisibilityTap?.call(!isVisible);
                    } else if (value == 'remove_tag') {
                      onRemoveTagTap?.call();
                    }
                  },
                  itemBuilder: (context) =>
                      _buildPopupMenuItems(context, currentUserId),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildPopupMenuItems(
    BuildContext context,
    String? currentUserId,
  ) {
    return [
      PopupMenuItem(
        value: 'share',
        child: Row(
          children: [
            Icon(Icons.share, size: 18, color: AppColors.iconPrimary),
            SizedBox(width: 8.rs(context)),
            Text(
              context.l10n.postShare,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.rsp(context),
              ),
            ),
          ],
        ),
      ),

      PopupMenuItem(
        value: 'save',
        child: Row(
          children: [
            Icon(
              isSaved == true
                  ? Icons.bookmark_remove_outlined
                  : Icons.bookmark_border,
              size: 18,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 8.rs(context)),
            Text(
              isSaved == true ? context.l10n.postUnsave : context.l10n.postSave,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.rsp(context),
              ),
            ),
          ],
        ),
      ),

      PopupMenuItem(
        value: 'report',
        child: Row(
          children: [
            Icon(Icons.flag_outlined, size: 18, color: Colors.red),
            SizedBox(width: 8.rs(context)),
            Text(
              context.l10n.postReport,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.rsp(context),
              ),
            ),
          ],
        ),
      ),

      // Thêm các option cho người được tag
      ..._buildTagOptions(context, currentUserId),
    ];
  }

  List<PopupMenuEntry<String>> _buildTagOptions(
    BuildContext context,
    String? currentUserId,
  ) {
    if (currentUserId == null) return [];

    // Kiểm tra xem current user có trong danh sách taggedUsers không
    final isTagged =
        taggedUsers?.any((u) => u.userId == currentUserId) ?? false;
    if (!isTagged) return [];

    final isVisible = visibleOnProfileUserIds?.contains(currentUserId) ?? false;

    return [
      PopupMenuItem(
        value: 'toggle_tag_visibility',
        child: Row(
          children: [
            Icon(
              isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: AppColors.iconPrimary,
            ),
            SizedBox(width: 8.rs(context)),
            Text(
              isVisible
                  ? context.l10n.postHideFromProfileTitle
                  : context.l10n.postShowOnProfileTitle,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.rsp(context),
              ),
            ),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'remove_tag',
        child: Row(
          children: [
            Icon(Icons.person_remove_outlined, size: 18, color: Colors.red),
            SizedBox(width: 8.rs(context)),
            Text(
              context.l10n.postRemoveTagTitle,
              style: TextStyle(color: Colors.red, fontSize: 14.rsp(context)),
            ),
          ],
        ),
      ),
    ];
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
