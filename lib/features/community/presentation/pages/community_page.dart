import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
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
  CommunityPage({super.key});

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
          CommunityListFetched(page: 1, limit: 10),
        );
      case 1:
        providerContext.read<CommunityListBloc>().add(MyCommunitiesFetched());
      case 2:
        providerContext.read<CommunityListBloc>().add(MyInvitesFetched());
      case 3:
        providerContext.read<CommunityListBloc>().add(
          PendingCommunitiesFetched(),
        );
      case 4:
        // Community posts tab
        providerContext.read<CommunityPostsTabBloc>().add(
          CommunityPostsTabFetched(status: 'all'),
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
    ).push(MaterialPageRoute(builder: (_) => CreateCommunityPage()));

    if (!mounted || !providerContext.mounted || result == null) {
      return;
    }

    _tabController.animateTo(1);
    providerContext.read<CommunityListBloc>().add(MyCommunitiesFetched());
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
                CommunityListFetched(page: 1, limit: 10),
              );
            }
          });

          return Container(
            color: AppColors.background,

            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: ResponsiveHelper.feedMaxWidth,
                ),

                child: Scaffold(
                  backgroundColor: AppColors.secondBackground,
                  appBar: AppBar(
                    toolbarHeight: 172,
                    titleSpacing: 0,
                    automaticallyImplyLeading: false,
                    title: SizedBox.shrink(),
                    backgroundColor: AppColors.secondBackground,
                    foregroundColor: AppColors.iconPrimary,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.18),
                                AppColors.background,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: -30,
                          top: -24,
                          child: Container(
                            width: 120.rs(context),
                            height: 120.rsh(context),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.background.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -40,
                          top: 20.rsh(context),
                          child: Container(
                            width: 110.rs(context),
                            height: 110.rsh(context),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.background.withValues(
                                alpha: 0.28,
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              6.rs(context),
                              4.rsh(context),
                              12.rs(context),
                              12.rsh(context),
                            ),
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
                                    icon: Icon(Icons.arrow_back_rounded),
                                    color: AppColors.iconPrimary,
                                    tooltip: context.l10n.commonBack,
                                    iconSize: 21.rsp(context),
                                    visualDensity: VisualDensity.compact,
                                    constraints: BoxConstraints(
                                      minWidth: 34.rs(context),
                                      minHeight: 34.rsh(context),
                                    ),
                                    padding: EdgeInsets.all(6.rs(context)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.rs(context),
                                  ),
                                  child: Text(
                                    context.l10n.communityExploreTitle,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 24.rsp(context),
                                      height: 1.1.rsh(context),
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.rsh(context)),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.rs(context),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          context.l10n.communityExploreSubtitle,
                                          maxLines: 2,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 12.rsp(context),
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.rs(context)),
                                      FilledButton.icon(
                                        onPressed: () =>
                                            _openCreateCommunity(newContext),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.rs(context),
                                            vertical: 6.rsh(context),
                                          ),
                                          minimumSize: Size(92, 32),
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.rsp(context),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.group_add,
                                          size: 15.rsp(context),
                                        ),
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.secondBackground,
                          AppColors.background,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 4.rsh(context), 0, 0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.divider,
                                width: 1,
                              ),
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
                            indicatorPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            indicatorWeight: 2.5,
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            labelPadding: EdgeInsets.symmetric(
                              horizontal: 16.rs(context),
                              vertical: 4.rsh(context),
                            ),
                            labelColor: AppColors.primary,
                            unselectedLabelColor: AppColors.textSecondary,
                            dividerColor: Colors.transparent,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2.5.rs(context),
                              ),
                            ),
                            tabs: [
                              Tab(
                                child: Text(
                                  context.l10n.communityExploreTab,
                                  style: TextStyle(
                                    fontSize: 13.rsp(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  context.l10n.communityMineTab,
                                  style: TextStyle(
                                    fontSize: 13.rsp(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  context.l10n.communityInvitesTab,
                                  style: TextStyle(
                                    fontSize: 13.rsp(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  context.l10n.communityPendingTab,
                                  style: TextStyle(
                                    fontSize: 13.rsp(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  context.l10n.communityPostsTab,
                                  style: TextStyle(
                                    fontSize: 13.rsp(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.rsh(context)),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
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
                ),
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
  CommunityPostsWidget({super.key});

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
      margin: EdgeInsets.fromLTRB(
        12.rs(context),
        0,
        12.rs(context),
        10.rsh(context),
      ),
      padding: EdgeInsets.fromLTRB(
        12.rs(context),
        10.rsh(context),
        10.rs(context),
        10.rsh(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.rsr(context)),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34.rs(context),
            height: 34.rsh(context),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.rsr(context)),
            ),
            child: Icon(
              _statusIcon(currentStatus),
              color: AppColors.primary,
              size: 19.rsp(context),
            ),
          ),
          SizedBox(width: 10.rs(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.communityPostsTab,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.rsp(context),
                  ),
                ),
                SizedBox(height: 2.rsh(context)),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 180),
                  child: Text(
                    _statusLabel(context, currentStatus),
                    key: ValueKey(currentStatus),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.rsp(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: context.l10n.communityFilterPosts,
            initialValue: currentStatus,
            color: AppColors.background,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.rsr(context)),
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
              padding: EdgeInsets.symmetric(
                horizontal: 10.rs(context),
                vertical: 7.rsh(context),
              ),
              decoration: BoxDecoration(
                color: AppColors.secondBackground,
                borderRadius: BorderRadius.circular(10.rsr(context)),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: AppColors.textSecondary,
                    size: 17.rsp(context),
                  ),
                  SizedBox(width: 5.rs(context)),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 18.rsp(context),
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
      duration: Duration(milliseconds: 260),
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
        key: ValueKey('error'),
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
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20.rsh(context)),
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

    return _PostsEmptyState(key: ValueKey('initial'), status: _selectedStatus);
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
        Icon(icon, size: 18.rsp(context), color: AppColors.primary),
        SizedBox(width: 10.rs(context)),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
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
      padding: EdgeInsets.fromLTRB(
        12.rs(context),
        0,
        12.rs(context),
        20.rsh(context),
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _AnimatedIn(
          index: index,
          child: Container(
            padding: EdgeInsets.all(14.rs(context)),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14.rsr(context)),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textSecondary.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SkeletonBox(
                      width: 42.rs(context),
                      height: 42.rsh(context),
                      radius: 21.rsr(context),
                    ),
                    SizedBox(width: 10.rs(context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SkeletonBox(
                            width: 160.rs(context),
                            height: 14.rsh(context),
                            radius: 7.rsr(context),
                          ),
                          SizedBox(height: 8.rsh(context)),
                          _SkeletonBox(
                            width: 94.rs(context),
                            height: 12.rsh(context),
                            radius: 6.rsr(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.rsh(context)),
                _SkeletonBox(
                  width: double.infinity,
                  height: 13.rsh(context),
                  radius: 7.rsr(context),
                ),
                SizedBox(height: 8.rsh(context)),
                _SkeletonBox(
                  width: 230.rs(context),
                  height: 13.rsh(context),
                  radius: 7.rsr(context),
                ),
                if (index == 0) ...[
                  SizedBox(height: 12.rsh(context)),
                  AspectRatio(
                    aspectRatio: 16 / 8.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.rsr(context)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 12.rsh(context)),
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
        padding: EdgeInsets.symmetric(horizontal: 28.rs(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 54.rsp(context),
              color: AppColors.textSecondary.withValues(alpha: 0.75),
            ),
            SizedBox(height: 12.rsh(context)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
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
        padding: EdgeInsets.symmetric(horizontal: 24.rs(context)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.rs(context)),
          decoration: BoxDecoration(
            color: Color(0xFFE11D48).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.rsr(context)),
            border: Border.all(
              color: Color(0xFFE11D48).withValues(alpha: 0.28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFE11D48),
                size: 30.rsp(context),
              ),
              SizedBox(height: 10.rsh(context)),
              Text(
                context.l10n.homeLoadPostsFailed,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4.rsh(context)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 12.rsh(context)),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh_rounded),
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
        color: AppColors.textSecondary.withValues(alpha: 0.2),
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
