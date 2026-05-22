import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_list_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_detail_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_admin_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_posts_tab_bloc.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_list_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/my_communities_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/my_invites_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/pending_communities_widget.dart';
import 'package:social_app_fe/features/community/presentation/pages/create_community_page.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BuildContext? _providerContext;
  bool _tabListenerAttached = false;
  int _lastDispatchedIndex = -1;
  bool _didInitialLoad = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void _onTabChanged(BuildContext providerContext, int index) {
    _lastDispatchedIndex = index;
    switch (index) {
      case 0:
        providerContext.read<CommunityListBloc>().add(
          const CommunityListFetched(page: 1, limit: 10),
        );
      case 1:
        providerContext.read<CommunityListBloc>().add(
          const MyCommunitiesFetched(),
        );
      case 2:
        providerContext.read<CommunityListBloc>().add(const MyInvitesFetched());
      case 3:
        providerContext.read<CommunityListBloc>().add(
          const PendingCommunitiesFetched(),
        );
      case 4:
        // Community posts tab
        providerContext.read<CommunityPostsTabBloc>().add(
          const CommunityPostsTabFetched(status: 'all'),
        );
    }
  }

  void _attachTabSwipeListener() {
    if (_tabListenerAttached) {
      return;
    }

    _tabController.addListener(() {
      if (!mounted || _providerContext == null) {
        return;
      }

      if (_tabController.indexIsChanging) {
        return;
      }

      final currentIndex = _tabController.index;
      if (currentIndex == _lastDispatchedIndex) {
        return;
      }

      _onTabChanged(_providerContext!, currentIndex);
    });

    _tabListenerAttached = true;
  }

  Future<void> _openCreateCommunity(BuildContext providerContext) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CreateCommunityPage()));

    if (!mounted || result == null) {
      return;
    }

    _tabController.animateTo(1);
    providerContext.read<CommunityListBloc>().add(const MyCommunitiesFetched());
    showSuccessSnackBar(context, context.l10n.communityCreateSuccess);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommunityListBloc>(
          create: (context) => s1<CommunityListBloc>(),
        ),
        BlocProvider<CommunityDetailBloc>(
          create: (context) => s1<CommunityDetailBloc>(),
        ),
        BlocProvider<CommunityAdminBloc>(
          create: (context) => s1<CommunityAdminBloc>(),
        ),
        BlocProvider<CommunityPostsTabBloc>(
          create: (context) => s1<CommunityPostsTabBloc>(),
        ),
      ],
      child: Builder(
        builder: (newContext) {
          _providerContext = newContext;
          _attachTabSwipeListener();

          // Load first tab after frame is rendered
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _didInitialLoad) {
              return;
            }

            if (_tabController.index == 0) {
              _didInitialLoad = true;
              newContext.read<CommunityListBloc>().add(
                const CommunityListFetched(page: 1, limit: 10),
              );
            }
          });

          return Scaffold(
            backgroundColor: const Color(0xFFF4F7FB),
            appBar: AppBar(
              toolbarHeight: 172,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              title: const SizedBox.shrink(),
              backgroundColor: const Color(0xFFF4F7FB),
              elevation: 0,
              scrolledUnderElevation: 0,
              flexibleSpace: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFCCFBF1), Color(0xFFEFF6FF)],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -30,
                    top: -24,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -40,
                    top: 20,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 4, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }
                              },
                              icon: const Icon(Icons.arrow_back_rounded),
                              color: const Color(0xFF0F172A),
                              tooltip: context.l10n.commonBack,
                              iconSize: 21,
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints(
                                minWidth: 34,
                                minHeight: 34,
                              ),
                              padding: const EdgeInsets.all(6),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              context.l10n.communityExploreTitle,
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 24,
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context.l10n.communityExploreSubtitle,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF475467),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                FilledButton.icon(
                                  onPressed: () =>
                                      _openCreateCommunity(newContext),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    minimumSize: const Size(92, 32),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  icon: const Icon(Icons.group_add, size: 15),
                                  label: Text(
                                    context.l10n.communityCreateGroup,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF4F7FB), Color(0xFFFFFFFF)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      onTap: (index) {
                        _onTabChanged(newContext, index);
                      },
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                      ),
                      indicatorWeight: 2.5,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      labelColor: AppColors.primary,
                      unselectedLabelColor: const Color(0xFF9CA3AF),
                      dividerColor: Colors.transparent,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2.5,
                        ),
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            context.l10n.communityExploreTab,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.communityMineTab,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.communityInvitesTab,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.communityPendingTab,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.communityPostsTab,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        CommunityListWidget(),
                        MyCommunitiesWidget(),
                        MyInvitesWidget(),
                        PendingCommunitiesWidget(),
                        CommunityPostsWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Tab: Các bài viết - Community posts
class CommunityPostsWidget extends StatefulWidget {
  const CommunityPostsWidget({super.key});

  @override
  State<CommunityPostsWidget> createState() => _CommunityPostsWidgetState();
}

class _CommunityPostsWidgetState extends State<CommunityPostsWidget> {
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityPostsTabBloc, CommunityPostsTabState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildFilterHeader(state),
            // Posts list
            Expanded(child: _buildPostsList(state)),
          ],
        );
      },
    );
  }

  Widget _buildFilterHeader(CommunityPostsTabState state) {
    final currentStatus = state is CommunityPostsTabLoaded
        ? state.status
        : _selectedStatus;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EAF0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _statusIcon(currentStatus),
              color: AppColors.primary,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.communityPostsTab,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    _statusLabel(context, currentStatus),
                    key: ValueKey(currentStatus),
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: context.l10n.communityFilterPosts,
            initialValue: currentStatus,
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (status) {
              setState(() => _selectedStatus = status);
              context.read<CommunityPostsTabBloc>().add(
                CommunityPostsTabStatusChanged(status: status),
              );
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'all',
                child: _PostFilterOption(
                  icon: Icons.dynamic_feed_rounded,
                  label: context.l10n.commonAll,
                ),
              ),
              PopupMenuItem(
                value: 'pending',
                child: _PostFilterOption(
                  icon: Icons.schedule_rounded,
                  label: context.l10n.communityPendingApproval,
                ),
              ),
              PopupMenuItem(
                value: 'approved',
                child: _PostFilterOption(
                  icon: Icons.verified_rounded,
                  label: context.l10n.communityApproved,
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5EAF0)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune_rounded, color: Color(0xFF475467), size: 17),
                  SizedBox(width: 5),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF667085),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(CommunityPostsTabState state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _buildPostsListContent(state),
    );
  }

  Widget _buildPostsListContent(CommunityPostsTabState state) {
    if (state is CommunityPostsTabLoading) {
      return const _PostsTabSkeleton(key: ValueKey('loading'));
    }

    if (state is CommunityPostsTabError) {
      return _PostsErrorState(
        key: const ValueKey('error'),
        message: localizedCommunityMessage(context.l10n, state.message),
        onRetry: () {
          context.read<CommunityPostsTabBloc>().add(
            CommunityPostsTabFetched(status: _selectedStatus),
          );
        },
      );
    }

    if (state is CommunityPostsTabLoaded) {
      if (state.posts.isEmpty) {
        return _PostsEmptyState(
          key: ValueKey('empty-${state.status}'),
          status: state.status,
        );
      }

      return ListView.builder(
        key: ValueKey('loaded-${state.status}-${state.posts.length}'),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        itemCount: state.posts.length,
        itemBuilder: (context, index) {
          final post = state.posts[index];
          final commentCount = state.commentCounts[post.id] ?? 0;
          return _AnimatedIn(
            index: index,
            child: PostItem(
              post: post,
              commentCount: commentCount,
              isInCommunityDetail: false,
            ),
          );
        },
      );
    }

    return _PostsEmptyState(
      key: const ValueKey('initial'),
      status: _selectedStatus,
    );
  }

  String _statusLabel(BuildContext context, String status) {
    switch (status) {
      case 'pending':
        return context.l10n.communityPendingApproval;
      case 'approved':
        return context.l10n.communityApproved;
      default:
        return context.l10n.commonAll;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'approved':
        return Icons.verified_rounded;
      default:
        return Icons.dynamic_feed_rounded;
    }
  }
}

class _PostFilterOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PostFilterOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _PostsTabSkeleton extends StatelessWidget {
  const _PostsTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _AnimatedIn(
          index: index,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE4E7EC)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F0F172A),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
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
                          _SkeletonBox(width: 160, height: 14, radius: 7),
                          SizedBox(height: 8),
                          _SkeletonBox(width: 94, height: 12, radius: 6),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const _SkeletonBox(
                  width: double.infinity,
                  height: 13,
                  radius: 7,
                ),
                const SizedBox(height: 8),
                const _SkeletonBox(width: 230, height: 13, radius: 7),
                if (index == 0) ...[
                  const SizedBox(height: 12),
                  AspectRatio(
                    aspectRatio: 16 / 8.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9EEF5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }
}

class _PostsEmptyState extends StatelessWidget {
  final String status;

  const _PostsEmptyState({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final message = _messageForStatus(context, status);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 54, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _messageForStatus(BuildContext context, String status) {
    switch (status) {
      case 'pending':
        return context.l10n.communityNoPendingPosts;
      case 'approved':
        return context.l10n.communityNoApprovedPosts;
      default:
        return context.l10n.communityNoPosts;
    }
  }
}

class _PostsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PostsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFECACA)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFE11D48),
                size: 30,
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.homeLoadPostsFailed,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF667085)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.commonRetry),
              ),
            ],
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
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _AnimatedIn extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedIn({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final delayMs = (index * 35).clamp(0, 240);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 220 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 14),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
