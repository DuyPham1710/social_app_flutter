import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_admin_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_detail_bloc.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_create_post_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_admin_panel.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_detail_header.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_members_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_posts_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/invite_friends_bottom_sheet.dart';
import 'package:social_app_fe/features/community/presentation/pages/community_create_post_page.dart';

class CommunityDetailPage extends StatefulWidget {
  final String communityId;

  const CommunityDetailPage({super.key, required this.communityId});

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  int _refreshSeed = 0;

  static const Color _pageBackground = Color(0xFFF0F2F5);

  void _refreshContent(BuildContext context) {
    setState(() {
      _refreshSeed++;
    });
    context.read<CommunityDetailBloc>().add(
      CommunityDetailFetched(widget.communityId),
    );
  }

  void _openCreatePost(BuildContext context, String? userRole) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommunityCreatePostPage(
          communityId: widget.communityId,
          userRole: userRole,
          onPostCreated: () => _refreshContent(context),
        ),
      ),
    );
  }

  void _showMembersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                'Thành viên cộng đồng',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: CommunityMembersWidget(
                  communityId: widget.communityId,
                  refreshSeed: _refreshSeed,
                  isInBottomSheet: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInviteFriendsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) =>
          InviteFriendsBottomSheet(communityId: widget.communityId),
    );
  }

  Widget _buildMembersButton(BuildContext context, int membersCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _showMembersBottomSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F3FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.group_rounded,
                    color: Color(0xFF1877F2),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thành viên',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1E21),
                        ),
                      ),
                      Text(
                        '$membersCount thành viên',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF65676B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Color(0xFF65676B),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommunityDetailBloc>(
          create: (_) =>
              s1<CommunityDetailBloc>()
                ..add(CommunityDetailFetched(widget.communityId)),
        ),
        BlocProvider<CommunityAdminBloc>(
          create: (_) => s1<CommunityAdminBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: _pageBackground,
        body: BlocConsumer<CommunityDetailBloc, CommunityDetailState>(
          listener: (context, state) {
            if (state is CommunityActionSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              _refreshContent(context);
            } else if (state is CommunityDetailError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is CommunityDetailLoading ||
                state is CommunityDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CommunityDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_tethering_error_rounded,
                      color: Colors.red[300],
                      size: 42,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(state.message, textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CommunityDetailBloc>().add(
                        CommunityDetailFetched(widget.communityId),
                      ),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            if (state is CommunityDetailLoaded) {
              final isMember =
                  state.memberStatus == 'member' || state.userRole == 'admin';

              return RefreshIndicator(
                onRefresh: () async => _refreshContent(context),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      titleSpacing: 0,
                      title: Text(
                        state.community.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF1C1E21),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: const Color(0xFF1C1E21),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.more_horiz_rounded),
                          color: const Color(0xFF1C1E21),
                          onPressed: () {},
                        ),
                      ],
                      expandedHeight: 240,
                      pinned: true,
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1C1E21),
                      surfaceTintColor: Colors.transparent,
                      scrolledUnderElevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        background:
                            (state.community.coverImage?.isNotEmpty ?? false)
                            ? Image.network(
                                state.community.coverImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFFBCC0C4),
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Color(0xFF65676B),
                                        size: 36,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF3A3B3C),
                                      Color(0xFF242526),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.groups_rounded,
                                    size: 52,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          CommunityDetailHeader(
                            community: state.community,
                            memberStatus: state.memberStatus,
                            userRole: state.userRole,
                            onJoin: () =>
                                context.read<CommunityDetailBloc>().add(
                                  JoinCommunityRequested(widget.communityId),
                                ),
                            onCancelRequest: () =>
                                context.read<CommunityDetailBloc>().add(
                                  CancelJoinRequestRequested(
                                    widget.communityId,
                                  ),
                                ),
                            onLeave: () =>
                                context.read<CommunityDetailBloc>().add(
                                  LeaveCommunityRequested(widget.communityId),
                                ),
                            onManage: state.userRole == 'admin'
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Dùng phần quản lý bên dưới để duyệt thành viên và bài viết',
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                          ),

                          _buildMembersButton(
                            context,
                            state.community.memberCount ?? 0,
                          ),
                          if (isMember)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () =>
                                      _showInviteFriendsBottomSheet(context),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE7F3FF),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.person_add_rounded,
                                            color: Color(0xFF1877F2),
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Mời bạn bè',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF1C1E21),
                                                ),
                                              ),
                                              Text(
                                                'Mời bạn bè tham gia',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF65676B),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color: Color(0xFF65676B),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (state.userRole == 'admin')
                            CommunityAdminPanel(
                              communityId: widget.communityId,
                            ),
                          const SizedBox(height: 8),
                          if (isMember)
                            CommunityCreatePostWidget(
                              avatarUrl: state.community.avatar,
                              onCreatePost: () =>
                                  _openCreatePost(context, state.userRole),
                            ),
                          const SizedBox(height: 8),
                          CommunityPostsWidget(
                            communityId: widget.communityId,
                            refreshSeed: _refreshSeed,
                            canViewPosts: isMember,
                            userRole: state.userRole,
                          ),
                          const SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text(''));
          },
        ),
      ),
    );
  }
}
