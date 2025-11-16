import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_relationship_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friends_by_userid_usecase.dart';
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
import 'package:timeago/timeago.dart' as timeago;

class PostHeader extends StatelessWidget {
  final UserEntity user;
  final DateTime? createdAt;
  const PostHeader({super.key, required this.user, this.createdAt});

  Future<void> _navigateToProfile(BuildContext context) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    // Nếu là user hiện tại → My Profile
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
      //Nếu là người khác → Other Profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OtherProfileBloc(
              getOtherUserProfileUseCase: di.s1<GetOtherUserProfileUseCase>(),
              getFriendsByUserIdUseCase: di.s1<GetFriendsByUserIdUseCase>(),
              getUserPostsUseCase: di.s1<GetUserPostsUseCase>(),
              getFriendRelationshipUseCase: di
                  .s1<GetFriendRelationshipUseCase>(),
              listenCommentCountUseCase: di.s1<ListenCommentCountUseCase>(),
              loadCommentsUseCase: di.s1<LoadCommentsUseCase>(),
            )..add(LoadOtherUserProfileEvent(userId: user.userId!)),
            child: OtherProfilePage(userId: user.userId!),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName ?? "Unknown",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  createdAt != null
                      ? timeago.format(createdAt!)
                      : "Unknown date",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.share, size: 20.sp),
        ],
      ),
    );
  }
}
