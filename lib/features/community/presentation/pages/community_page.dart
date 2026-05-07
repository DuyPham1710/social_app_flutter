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
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

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
        break;
      case 1:
        providerContext.read<CommunityListBloc>().add(
          const MyCommunitiesFetched(),
        );
        break;
      case 2:
        providerContext.read<CommunityListBloc>().add(const MyInvitesFetched());
        break;
      case 3:
        providerContext.read<CommunityListBloc>().add(
          const PendingCommunitiesFetched(),
        );
        break;
      case 4:
        // Community posts tab
        providerContext.read<CommunityPostsTabBloc>().add(
          const CommunityPostsTabFetched(status: 'all'),
        );
        break;
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
    showSuccessSnackBar(context, 'Đã tạo cộng đồng mới');
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
                              tooltip: 'Quay lại',
                              iconSize: 21,
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints(
                                minWidth: 34,
                                minHeight: 34,
                              ),
                              padding: const EdgeInsets.all(6),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Khám phá cộng đồng',
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
                                const Expanded(
                                  child: Text(
                                    'Tìm những cộng đồng phù hợp với sở thích của bạn',
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
                                  label: const Text('Tạo nhóm'),
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
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2.5,
                        ),
                      ),
                      tabs: const [
                        Tab(
                          child: Text(
                            'Tìm kiếm',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Của tôi',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Lời mời',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Chờ duyệt',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Bài viết',
                            style: TextStyle(
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityPostsTabBloc, CommunityPostsTabState>(
      builder: (context, state) {
        return Column(
          children: [
            // Filter buttons
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildFilterButton('all', 'Tất cả', state),
                  const SizedBox(width: 8),
                  _buildFilterButton('pending', 'Chờ duyệt', state),
                  const SizedBox(width: 8),
                  _buildFilterButton('approved', 'Đã duyệt', state),
                ],
              ),
            ),
            // Posts list
            Expanded(child: _buildPostsList(state)),
          ],
        );
      },
    );
  }

  Widget _buildFilterButton(
    String status,
    String label,
    CommunityPostsTabState state,
  ) {
    final isSelected =
        state is CommunityPostsTabLoaded && state.status == status;
    return GestureDetector(
      onTap: () {
        context.read<CommunityPostsTabBloc>().add(
          CommunityPostsTabStatusChanged(status: status),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPostsList(CommunityPostsTabState state) {
    if (state is CommunityPostsTabLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CommunityPostsTabError) {
      return Center(child: Text('Lỗi: ${state.message}'));
    }

    if (state is CommunityPostsTabLoaded) {
      if (state.posts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_outlined, size: 54, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'Chưa có bài viết nào',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: state.posts.length,
        itemBuilder: (context, index) {
          final post = state.posts[index];
          final commentCount = state.commentCounts[post.id] ?? 0;
          return PostItem(
            post: post,
            commentCount: commentCount,
            isInCommunityDetail: false,
          );
        },
      );
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 54, color: Color(0xFFD1D5DB)),
          SizedBox(height: 12),
          Text(
            'Chưa có bài viết nào',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
