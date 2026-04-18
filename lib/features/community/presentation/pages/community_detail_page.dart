import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_admin_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_detail_bloc.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_admin_panel.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_detail_header.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_members_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_posts_widget.dart';
import 'package:social_app_fe/features/post/presentation/pages/create_post_page.dart';

class CommunityDetailPage extends StatefulWidget {
  final String communityId;

  const CommunityDetailPage({super.key, required this.communityId});

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  int _refreshSeed = 0;

  void _refreshContent(BuildContext context) {
    setState(() {
      _refreshSeed++;
    });
    context.read<CommunityDetailBloc>().add(
      CommunityDetailFetched(widget.communityId),
    );
  }

  void _openCreatePost(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreatePostPage(
          communityId: widget.communityId,
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

  Widget _buildMembersButton(BuildContext context, int membersCount) {
    return GestureDetector(
      onTap: () => _showMembersBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E7EC)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x120F172A),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.people_alt_outlined,
                color: Color(0xFF0F766E),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thành viên',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      '$membersCount thành viên',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
            ],
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
        backgroundColor: const Color(0xFFF4F7FB),
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
                      title: Text(
                        state.community.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      centerTitle: false,
                      expandedHeight: 220,
                      pinned: true,
                      backgroundColor: const Color(0xFFF4F7FB),
                      flexibleSpace: FlexibleSpaceBar(
                        background:
                            (state.community.coverImage?.isNotEmpty ?? false)
                            ? Image.network(
                                state.community.coverImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF0EA5E9),
                                      Color(0xFF1D4ED8),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.groups,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            onCreatePost: isMember
                                ? () => _openCreatePost(context)
                                : null,
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
                          if (state.userRole == 'admin')
                            CommunityAdminPanel(
                              communityId: widget.communityId,
                            ),
                          const SizedBox(height: 16),
                          _buildMembersButton(
                            context,
                            state.community.memberCount ?? 0,
                          ),
                          const SizedBox(height: 16),
                          CommunityPostsWidget(
                            communityId: widget.communityId,
                            refreshSeed: _refreshSeed,
                            canCreatePost: isMember,
                            canViewPosts: isMember,
                            onCreatePost: isMember
                                ? () => _openCreatePost(context)
                                : null,
                          ),
                          const SizedBox(height: 30),
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
        floatingActionButton:
            BlocBuilder<CommunityDetailBloc, CommunityDetailState>(
              builder: (context, state) {
                final canCreatePost =
                    state is CommunityDetailLoaded &&
                    (state.memberStatus == 'member' ||
                        state.userRole == 'admin');

                if (!canCreatePost) return const SizedBox.shrink();

                return FloatingActionButton.extended(
                  onPressed: () => _openCreatePost(context),
                  backgroundColor: const Color(0xFF0F766E),
                  icon: const Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Đăng bài',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
