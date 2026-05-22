import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friend_for_user_page.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/friend_list_widget.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/other_profile_header.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/profile_info.dart';
import 'package:social_app_fe/l10n/l10n.dart';
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
  static const Duration _fadeDuration = Duration(milliseconds: 260);

  @override
  void initState() {
    super.initState();

    _loadData();

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

  void _loadData() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OtherProfileBloc, OtherProfileState>(
        builder: (context, state) {
          if (state is OtherProfileError && state.user == null) {
            return _fadeContent(
              key: 'other-profile-error',
              child: _buildErrorProfile(
                state.error ?? context.l10n.profileLoadError,
              ),
            );
          }

          if (state is OtherProfileLoading || state.user == null) {
            return _fadeContent(
              key: 'other-profile-loading',
              child: _buildLoadingProfile(),
            );
          }

          final user = state.user!;
          final posts = state.posts ?? [];
          final commentCounts = state.commentCounts ?? {};

          return _fadeContent(
            key: 'other-profile-loaded-${user.userId}',
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.background,
              onRefresh: () async {
                _loadData();
                // Cho animation refresh mượt hơn
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    surfaceTintColor: Colors.transparent,
                    pinned: true,
                    backgroundColor: AppColors.background,
                    elevation: 0,
                    title: Text(
                      user.fullName ?? context.l10n.profileTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  /// Content
                  SliverList(
                    delegate: SliverChildListDelegate([
                      OtherProfileHeader(user: user),

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

                      ProfileInfo(user: user),
                      const Divider(),
                      FriendListWidget(
                        onViewAll: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendForUserPage(
                                userId: user.userId,
                                username: user.username ?? "user",
                                fullName:
                                    user.fullName ?? context.l10n.commonUser,
                              ),
                            ),
                          );
                          _loadData();
                        },
                      ),
                      const Divider(),
                      const SizedBox(height: 12),
                      _buildPostsSection(state, posts, commentCounts),
                    ]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _fadeContent({required String key, required Widget child}) {
    return AnimatedSwitcher(
      duration: _fadeDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(key: ValueKey(key), child: child),
    );
  }

  Widget _buildLoadingProfile() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          surfaceTintColor: Colors.transparent,
          pinned: true,
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            context.l10n.profileTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const OtherProfileHeader(isLoading: true),
            const _ProfileActionSkeleton(),
            const Divider(),
            const _ProfileInfoSkeleton(),
            const Divider(),
            const _PostSkeletonList(),
          ]),
        ),
      ],
    );
  }

  Widget _buildErrorProfile(String message) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          surfaceTintColor: Colors.transparent,
          pinned: true,
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            context.l10n.profileTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFE11D48),
                    size: 42,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 14.h),
                  OutlinedButton.icon(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(context.l10n.commonRetry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostsSection(
    OtherProfileState state,
    List posts,
    Map<String, int> commentCounts,
  ) {
    return Column(
      children: [
        if (state is OtherProfileLoaded &&
            posts.isEmpty &&
            state.currentPage == null)
          const _PostSkeletonList(),
        if (state is OtherProfileError)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                state.error ?? context.l10n.profileLoadPostsError,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        if (posts.isEmpty &&
            state is! OtherProfileError &&
            !(state is OtherProfileLoaded && state.currentPage == null))
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              context.l10n.profileNoPosts,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ),
        ...posts.map((post) {
          final count = commentCounts[post.id] ?? 0;
          return PostItem(post: post, commentCount: count);
        }),
        if (state is OtherProfileLoaded && state.isLoadingMore)
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        if (state is OtherProfileLoaded &&
            state.hasNext == false &&
            posts.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Center(
              child: Text(
                context.l10n.profileEndOfPosts,
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProfileActionSkeleton extends StatelessWidget {
  const _ProfileActionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: const [
          Expanded(child: _SkeletonBox(height: 38, radius: 10)),
          SizedBox(width: 10),
          _SkeletonBox(width: 92, height: 38, radius: 10),
          SizedBox(width: 10),
          _SkeletonBox(width: 44, height: 38, radius: 10),
        ],
      ),
    );
  }
}

class _ProfileInfoSkeleton extends StatelessWidget {
  const _ProfileInfoSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SkeletonBox(width: 210, height: 14, radius: 7),
          SizedBox(height: 10),
          _SkeletonBox(width: 160, height: 14, radius: 7),
          SizedBox(height: 10),
          _SkeletonBox(width: 190, height: 14, radius: 7),
        ],
      ),
    );
  }
}

class _PostSkeletonList extends StatelessWidget {
  const _PostSkeletonList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        children: List.generate(
          2,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.secondBackground,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    _SkeletonBox(width: 42, height: 42, radius: 21),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SkeletonBox(width: 150, height: 14, radius: 7),
                          SizedBox(height: 8),
                          _SkeletonBox(width: 90, height: 12, radius: 6),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                const _SkeletonBox(
                  width: double.infinity,
                  height: 13,
                  radius: 7,
                ),
                SizedBox(height: 8.h),
                const _SkeletonBox(width: 230, height: 13, radius: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _SkeletonBox({this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.background : const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
