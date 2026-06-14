import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_relationship_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_user_posts_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_other_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:social_app_fe/features/search/domain/entities/search_history_entity.dart';
import 'package:social_app_fe/features/search/presentation/bloc/search_bloc.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class SearchHistoryItem extends StatelessWidget {
  final SearchHistoryEntity history;
  final bool showDeleteIcon;

  const SearchHistoryItem({
    super.key,
    required this.history,
    this.showDeleteIcon = false,
  });

  Widget _buildHeader(
    BuildContext context, {
    required bool hasViewedUser,
    required String displayName,
    required String? avatarUrl,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.rs(context),
        vertical: 16.rsh(context),
      ),
      child: Row(
        children: [
          hasViewedUser
              ? CircleAvatar(
                  radius: 24.rsr(context),
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null || avatarUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 24.rsr(context),
                          color: AppColors.textSecondary,
                        )
                      : null,
                )
              : Container(
                  width: 48.rsr(context),
                  height: 48.rsr(context),
                  decoration: BoxDecoration(
                    color: AppColors.secondBackground,
                    borderRadius: BorderRadius.circular(24.rsr(context)),
                  ),
                  child: Icon(
                    CupertinoIcons.search,
                    size: 20.rsr(context),
                    color: AppColors.textSecondary,
                  ),
                ),
          SizedBox(width: 12.rs(context)),
          Expanded(
            child: Text(
              displayName,
              style: TextStyle(
                fontSize: 16.rsp(context),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.rs(context),
          vertical: 16.rsh(context),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22.rsr(context), color: AppColors.textPrimary),
            SizedBox(width: 16.rs(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.rsp(context),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.rsh(context)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.rsp(context),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    final hasViewedUser = history.viewedUser != null;
    final displayName = hasViewedUser
        ? (history.viewedUser!.fullName ??
              history.viewedUser!.username ??
              context.l10n.commonUser)
        : history.query!;
    final avatarUrl = hasViewedUser ? history.viewedUser!.avatarUrl : null;

    // Lưu SearchBloc từ context cha trước khi show bottom sheet
    final searchBloc = context.read<SearchBloc>();

    if (ResponsiveHelper.isWebOrDesktop) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.background,
          clipBehavior: Clip.antiAlias,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.rsr(context)),
          ),
          content: SizedBox(
            width: 320.rs(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header với avatar và tên
                _buildHeader(
                  context,
                  hasViewedUser: hasViewedUser,
                  displayName: displayName,
                  avatarUrl: avatarUrl,
                ),
                // Đường phân cách
                Divider(color: AppColors.divider, height: 1, thickness: 1),
                // Action: Xóa
                _buildActionItem(
                  context,
                  icon: CupertinoIcons.delete,
                  title: context.l10n.commonDelete,
                  subtitle: context.l10n.searchRemoveFromHistory,
                  onTap: () {
                    Navigator.pop(dialogContext);
                    searchBloc.add(DeleteSearchHistory(historyId: history.id));
                  },
                ),
                // Action: Ghim
                _buildActionItem(
                  context,
                  icon: CupertinoIcons.pin,
                  title: context.l10n.searchPinThis,
                  subtitle: context.l10n.searchPinLimit,
                  onTap: () {
                    Navigator.pop(dialogContext);
                    // TODO: Implement pin functionality
                  },
                ),
                SizedBox(height: 8.rsh(context)),
              ],
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (bottomSheetContext) => Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.rsr(context)),
              topRight: Radius.circular(20.rsr(context)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.rsh(context)),
                width: 40.rs(context),
                height: 4.rsh(context),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2.rsr(context)),
                ),
              ),
              // Header với avatar và tên
              _buildHeader(
                context,
                hasViewedUser: hasViewedUser,
                displayName: displayName,
                avatarUrl: avatarUrl,
              ),
              // Đường phân cách
              Divider(color: AppColors.divider, height: 1, thickness: 1),
              // Action: Xóa
              _buildActionItem(
                context,
                icon: CupertinoIcons.delete,
                title: context.l10n.commonDelete,
                subtitle: context.l10n.searchRemoveFromHistory,
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  searchBloc.add(DeleteSearchHistory(historyId: history.id));
                },
              ),
              // Action: Ghim
              _buildActionItem(
                context,
                icon: CupertinoIcons.pin,
                title: context.l10n.searchPinThis,
                subtitle: context.l10n.searchPinLimit,
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  // TODO: Implement pin functionality
                },
              ),
              SizedBox(height: 8.rsh(context)),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _handleTap(BuildContext context) async {
    if (!context.mounted) return;

    // Nếu có viewedUser, navigate đến profile của user đó
    if (history.viewedUser != null) {
      final user = history.viewedUser!;
      final userData = await TokenStorage.getUserData();
      final currentUserId = userData?['id'];

      if (!context.mounted) return;

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => OtherProfileBloc(
                getOtherUserProfileUseCase: di.s1<GetOtherUserProfileUseCase>(),
                getUserPostsUseCase: di.s1<GetUserPostsUseCase>(),
                getFriendRelationshipUseCase: di
                    .s1<GetFriendRelationshipUseCase>(),
                listenCommentCountUseCase: di.s1<ListenCommentCountUseCase>(),
                loadCommentsUseCase: di.s1<LoadCommentsUseCase>(),
              )..add(LoadOtherUserProfileEvent(userId: user.userId)),
              child: OtherProfilePage(userId: user.userId),
            ),
          ),
        );
      }
    } else if (history.query != null && history.query!.isNotEmpty) {
      // Nếu có query, trigger search với query đó
      if (context.mounted) {
        context.read<SearchBloc>().add(SearchUsers(query: history.query!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasViewedUser = history.viewedUser != null;
    final hasQuery = history.query != null && history.query!.isNotEmpty;

    if (!hasViewedUser && !hasQuery) {
      return const SizedBox.shrink();
    }

    final displayName = hasViewedUser
        ? (history.viewedUser!.fullName ??
              history.viewedUser!.username ??
              context.l10n.commonUser)
        : history.query!;
    final avatarUrl = hasViewedUser ? history.viewedUser!.avatarUrl : null;
    final subtitle = hasViewedUser
        ? (history.viewedUser!.username != null
              ? '@${history.viewedUser!.username}'
              : null)
        : null;

    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(12.rsr(context)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.rsh(context),
          horizontal: 12.rs(context),
        ),
        child: Row(
          children: [
            // Avatar hoặc icon
            if (hasViewedUser)
              CircleAvatar(
                radius: 24.rsr(context),
                backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 24.rsr(context),
                        color: AppColors.textSecondary,
                      )
                    : null,
              )
            else
              Container(
                width: 48.rsr(context),
                height: 48.rsr(context),
                decoration: BoxDecoration(
                  color: AppColors.secondBackground,
                  borderRadius: BorderRadius.circular(24.rsr(context)),
                ),
                child: Icon(
                  CupertinoIcons.search,
                  size: 20.rsr(context),
                  color: AppColors.textSecondary,
                ),
              ),
            SizedBox(width: 12.rs(context)),
            // Thông tin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 15.rsp(context),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.rsh(context)),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.rsp(context),
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Icon menu (3 chấm) hoặc icon X (xóa)
            showDeleteIcon
                ? IconButton(
                    icon: Icon(
                      CupertinoIcons.xmark,
                      size: 20.rsr(context),
                      color: AppColors.iconPrimary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      context.read<SearchBloc>().add(
                        DeleteSearchHistory(historyId: history.id),
                      );
                    },
                  )
                : IconButton(
                    icon: Icon(
                      CupertinoIcons.ellipsis,
                      size: 20.rsr(context),
                      color: AppColors.iconPrimary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
