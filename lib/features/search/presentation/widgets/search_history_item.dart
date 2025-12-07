import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_relationship_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_profile_posts_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_user_posts_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_other_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/features/search/domain/entities/search_history_entity.dart';
import 'package:social_app_fe/features/search/domain/repository/search_repository.dart';
import 'package:social_app_fe/features/search/presentation/bloc/search_bloc.dart';

class SearchHistoryItem extends StatelessWidget {
  final SearchHistoryEntity history;

  const SearchHistoryItem({
    super.key,
    required this.history,
  });

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
              create: (_) => ProfileBloc(
                getProfilePostsUseCase: di.s1<GetProfilePostsUseCase>(),
                listenCommentCountUseCase: di.s1<ListenCommentCountUseCase>(),
                loadCommentsUseCase: di.s1<LoadCommentsUseCase>(),
                getUserProfileUseCase: di.s1<GetUserProfileUseCase>(),
              )..add(const LoadUserProfileEvent()),
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
                getFriendRelationshipUseCase:
                    di.s1<GetFriendRelationshipUseCase>(),
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
        ? (history.viewedUser!.fullName ?? history.viewedUser!.username ?? 'Người dùng')
        : history.query!;
    final avatarUrl = hasViewedUser ? history.viewedUser!.avatarUrl : null;
    final subtitle = hasViewedUser
        ? (history.viewedUser!.username != null ? '@${history.viewedUser!.username}' : null)
        : null;

    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        child: Row(
          children: [
            // Avatar hoặc icon
            if (hasViewedUser)
              CircleAvatar(
                radius: 24.r,
                backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 24.r,
                        color: Colors.grey[400],
                      )
                    : null,
              )
            else
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  CupertinoIcons.search,
                  size: 20.r,
                  color: Colors.grey[600],
                ),
              ),
            SizedBox(width: 12.w),
            // Thông tin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Icon menu (3 chấm)
            IconButton(
              icon: Icon(
                CupertinoIcons.ellipsis,
                size: 20.r,
                color: Colors.grey[600],
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                // TODO: Hiển thị menu xóa lịch sử
              },
            ),
          ],
        ),
      ),
    );
  }
}

