import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friend_for_user_page.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/friend_list_widget.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/other_profile_header.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/profile_info.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/profile_loading_skeleton.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import '../widgets/other_profile_actions.dart';
import '../bloc/other_profile_bloc.dart';
import '../bloc/other_profile_state.dart';
import '../bloc/other_profile_event.dart';
import '../widgets/report_user_bottom_sheet.dart';

import 'package:social_app_fe/core/di/injection.dart' as di;

class OtherProfilePage extends StatelessWidget {
  final String userId;

  const OtherProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FriendProfileBloc>(
      create: (_) => di.s1<FriendProfileBloc>(),
      child: _OtherProfilePageView(userId: userId),
    );
  }
}

class _OtherProfilePageView extends StatefulWidget {
  final String userId;

  const _OtherProfilePageView({super.key, required this.userId});

  @override
  State<_OtherProfilePageView> createState() => _OtherProfilePageViewState();
}

class _OtherProfilePageViewState extends State<_OtherProfilePageView> {
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ResponsiveHelper.feedMaxWidth,
          ),
          child: BlocBuilder<OtherProfileBloc, OtherProfileState>(
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
                  color: AppColors.textSecondary,
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
                        actions: [
                          PopupMenuButton<String>(
                            tooltip: '',
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                16.rsr(context),
                              ),
                            ),
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: AppColors.textPrimary,
                              size: 24.rs(context),
                            ),
                            onSelected: (value) {
                              if (value == 'report') {
                                ReportUserBottomSheet.show(
                                  context,
                                  reportedUserId: user.userId,
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'report',
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.rs(context),
                                  vertical: 4.rsh(context),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      12.rsr(context),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.rs(context)),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.rsr(context),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.report_gmailerrorred_rounded,
                                          color: Colors.red,
                                          size: 20.rs(context),
                                        ),
                                      ),
                                      SizedBox(width: 12.rs(context)),
                                      Expanded(
                                        child: Text(
                                          context.l10n.profileReportUser,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.rsp(context),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                                  requestId:
                                      state.relationship?.requestId ?? '',
                                ),
                              );
                            },
                            onAcceptRequest: () {
                              context.read<FriendProfileBloc>().add(
                                AcceptFriendRequest(
                                  requestId:
                                      state.relationship?.requestId ?? '',
                                  userId: user.userId,
                                ),
                              );
                            },
                            onRejectRequest: () {
                              context.read<FriendProfileBloc>().add(
                                RejectFriendRequest(
                                  requestId:
                                      state.relationship?.requestId ?? '',
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
                          //Divider(color: AppColors.divider),
                          FriendListWidget(
                            onViewAll: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FriendForUserPage(
                                    userId: user.userId,
                                    username: user.username ?? "user",
                                    fullName:
                                        user.fullName ??
                                        context.l10n.commonUser,
                                  ),
                                ),
                              );
                              _loadData();
                            },
                          ),
                          //Divider(color: AppColors.divider),
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
        ),
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
          title: const ProfileSkeletonShimmer(
            child: ProfileSkeletonBox(width: 100, height: 24, radius: 12),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const OtherProfileHeader(isLoading: true),
            const ProfileActionSkeleton(),
            Divider(color: AppColors.divider, height: 1),
            const ProfileInfoSkeleton(),
            Divider(color: AppColors.divider, height: 1),
            const ProfileFriendsSkeleton(),
            Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 12),
            const ProfilePostSkeletonList(),
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
              padding: EdgeInsets.all(24.rs(context)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFE11D48),
                    size: 42,
                  ),
                  SizedBox(height: 12.rsh(context)),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 14.rsh(context)),
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
          const ProfilePostSkeletonList(),
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
            padding: EdgeInsets.all(16.rs(context)),
            child: Text(
              context.l10n.profileNoPosts,
              style: TextStyle(color: Colors.grey, fontSize: 14.rsp(context)),
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
              child: CircularProgressIndicator(color: AppColors.textSecondary),
            ),
          ),
        if (state is OtherProfileLoaded &&
            state.hasNext == false &&
            posts.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.rsh(context)),
            child: Center(
              child: Text(
                context.l10n.profileEndOfPosts,
                style: TextStyle(color: Colors.grey, fontSize: 14.rsp(context)),
              ),
            ),
          ),
      ],
    );
  }
}
