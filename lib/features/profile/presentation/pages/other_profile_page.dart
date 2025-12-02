import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/friend_list_widget.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/profile_header.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/profile_info.dart';
import '../widgets/other_profile_actions.dart';
import '../bloc/other_profile_bloc.dart';
import '../bloc/other_profile_state.dart';
import '../bloc/other_profile_event.dart';

class OtherProfilePage extends StatefulWidget {
  final String userId;

  const OtherProfilePage({super.key, required this.userId});

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    /// Load user & relationship
    context.read<OtherProfileBloc>().add(
      LoadOtherUserProfileEvent(userId: widget.userId),
    );

    /// Load posts page 1
    context.read<OtherProfileBloc>().add(
      LoadOtherProfilePostsEvent(userId: widget.userId, page: 1),
    );

    //lấy bạn bè
    context.read<FriendProfileBloc>().add(LoadFriendsByUserId(widget.userId));

    /// Handle load more when scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<OtherProfileBloc>().add(
          LoadMoreOtherProfilePostsEvent(userId: widget.userId),
        );
      }
    });

    /// Listen to FriendBloc actions (gửi/hủy/accept friend request)
    context.read<FriendProfileBloc>().stream.listen((state) {
      if (mounted) {
        /// reload lại relationship
        context.read<OtherProfileBloc>().add(
          ReloadRelationshipEvent(widget.userId),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OtherProfileBloc, OtherProfileState>(
        builder: (context, state) {
          if (state is OtherProfileLoading || state.user == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final user = state.user!;
          final posts = state.posts ?? [];
          final commentCounts = state.commentCounts ?? {};

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                surfaceTintColor: Colors.transparent,
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                title: Text(
                  user.fullName ?? "Trang cá nhân",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              /// Content
              SliverList(
                delegate: SliverChildListDelegate([
                  ProfileHeader(user: user),

                  /// Friend actions
                  OtherProfileActions(
                    relationship: state.relationship,
                    onSendRequest: () {
                      context.read<FriendProfileBloc>().add(
                        SendFriendRequest(receiverId: user.userId),
                      );
                    },
                    onCancelRequest: () {
                      context.read<FriendProfileBloc>().add(
                        CancelSentFriendRequest(
                          requestId: state.relationship?.requestId ?? '',
                        ),
                      );
                    },
                    onAcceptRequest: () {
                      context.read<FriendProfileBloc>().add(
                        AcceptFriendRequest(
                          requestId: state.relationship?.requestId ?? '',
                          userId: user.userId,
                        ),
                      );
                    },
                    onRejectRequest: () {
                      context.read<FriendProfileBloc>().add(
                        RejectFriendRequest(
                          requestId: state.relationship?.requestId ?? '',
                        ),
                      );
                    },
                    onUnfriend: () {
                      context.read<FriendProfileBloc>().add(
                        RemoveFriend(friendId: user.userId),
                      );
                    },
                    onMessage: () {
                      // TODO: open chat
                    },
                  ),

                  const ProfileInfo(),
                  Divider(),
                  FriendListWidget(
                    onViewAll: () => Navigator.pushNamed(context, '/friends'),
                    userId: user.userId,
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  /// Posts
                  if (posts.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Chưa có bài viết nào"),
                      ),
                    ),

                  ...posts.map((post) {
                    final count = commentCounts[post.id] ?? 0;
                    return PostItem(post: post, commentCount: count);
                  }),

                  /// Loading more indicator
                  if (state is OtherProfileLoaded && state.isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                  /// End of posts
                  if (state is OtherProfileLoaded &&
                      state.hasNext == false &&
                      posts.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: Text(
                          "Đã hiển thị hết bài viết",
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      ),
                    ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
