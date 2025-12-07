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
  final bool showDeleteIcon;

  const SearchHistoryItem({
    super.key,
    required this.history,
    this.showDeleteIcon = false,
  });

  void _showBottomSheet(BuildContext context) {
    final hasViewedUser = history.viewedUser != null;
    final displayName = hasViewedUser
        ? (history.viewedUser!.fullName ?? history.viewedUser!.username ?? 'Người dùng')
        : history.query!;
    final avatarUrl = hasViewedUser ? history.viewedUser!.avatarUrl : null;
    
    // Lưu SearchBloc từ context cha trước khi show bottom sheet
    final searchBloc = context.read<SearchBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // Header với avatar và tên
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  hasViewedUser
                      ? CircleAvatar(
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
                      : Container(
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
                  Expanded(
                    child: Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Đường phân cách
            Divider(
              color: Colors.grey[800],
              height: 1,
              thickness: 1,
            ),
            // Action: Xóa
            InkWell(
              onTap: () {
                Navigator.pop(bottomSheetContext);
                searchBloc.add(
                  DeleteSearchHistory(historyId: history.id),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.delete,
                      size: 22.r,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xóa',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Gỡ khỏi lịch sử tìm kiếm của bạn.',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action: Ghim
            InkWell(
              onTap: () {
                Navigator.pop(bottomSheetContext);
                // TODO: Implement pin functionality
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.pin,
                      size: 22.r,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ghim nội dung tìm kiếm này',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Bạn chỉ có thể ghim 3 nội dung tìm kiếm cùng lúc.',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
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
            // Icon menu (3 chấm) hoặc icon X (xóa)
            showDeleteIcon
                ? IconButton(
                    icon: Icon(
                      CupertinoIcons.xmark,
                      size: 20.r,
                      color: Colors.grey[600],
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
                      size: 20.r,
                      color: Colors.grey[600],
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
