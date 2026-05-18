import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_event.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_state.dart';
import 'package:social_app_fe/features/home/presentation/widgets/home_header_widget.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_state.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_creating_progress.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/posts_loading_widget.dart';
import 'package:social_app_fe/features/story/presentation/widgets/home_stories_widget.dart';
import 'package:social_app_fe/features/story/presentation/bloc/home_stories_bloc.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Chỉ khởi tạo WebSocket, việc load posts sẽ được tự động trigger
    // sau khi WebSocket connect xong
    context.read<HomeBloc>().add(const InitializeWebSocketEvent());

    // Lắng nghe sự kiện scroll để load more
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeBloc>().add(const LoadMorePostsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger khi còn 200px nữa là tới cuối
    return currentScroll >= (maxScroll - 200);
  }

  Future<void> _onRefresh() async {
    // Load lại posts từ đầu (page 1)
    context.read<HomeBloc>().add(LoadPostsEvent(page: 1, limit: 2));
    // Reload stories as well
    try {
      context.read<HomeStoriesBloc>().add(
        const LoadHomeStoriesEvent(page: 1, limit: 5),
      );
    } catch (_) {
      // Nếu HomeStoriesBloc chưa được provide ở trên (ví dụ provider nằm trong widget khác),
      // thì không làm gì để tránh crash. Caller có thể wrap HomeStoriesWidget với BlocProvider.
    }
  }

  void scrollToTopOrRefresh() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset > 0) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _onRefresh();
      }
    } else {
      _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            backgroundColor: AppColors.background,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 64.h,
                  titleSpacing: 0,
                  title: HomeHeaderWidget(),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      HomeStoriesWidget(page: 1, limit: 5),

                      BlocBuilder<PostBloc, PostState>(
                        builder: (context, postState) {
                          if (postState is PostCreating) {
                            return const PostCreatingProgress();
                          }
                          return const SizedBox.shrink(); // Không hiển thị nếu không tạo post
                        },
                      ),

                      if (state is HomeInitializing)
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Đang kết nối...",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (state is HomeLoading) const PostsLoadingWidget(),

                      if (state is HomeError)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              state.errorMessage ?? "Không thể tải bài viết",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                if (state is HomeLoaded)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = state.posts![index];
                      final commentCount = state.commentCounts?[post.id] ?? 0;
                      return PostItem(post: post, commentCount: commentCount);
                    }, childCount: state.posts?.length ?? 0),
                  ),

                if (state is HomeLoaded)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Loading indicator khi đang load more
                        if (state.isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),

                        // Hiển thị thông báo khi hết data
                        if (state.hasNext == false && !state.isLoadingMore)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Center(
                              child: Text(
                                "Đã hiển thị hết bài viết",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
