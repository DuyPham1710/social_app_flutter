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
import 'package:social_app_fe/features/story/presentation/widgets/home_stories_widget.dart';
import 'package:social_app_fe/features/story/presentation/bloc/home_stories_bloc.dart';
import 'package:social_app_fe/shared/component/custom_refresh_header.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
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
    _refreshController.dispose();
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

  void _onRefresh() async {
    // Load lại posts từ đầu (page 1)
    await Future.delayed(const Duration(milliseconds: 1000));
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
    // Listener sẽ tự động complete refresh khi state thay đổi
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded || state is HomeError) {
            // Hoàn thành refresh ngay lập tức
            _refreshController.refreshCompleted(resetFooterState: true);
          }
        },

        builder: (context, state) {
          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            // Tắt hiệu ứng đàn hồi
            physics: const AlwaysScrollableScrollPhysics(),
            header: const CustomRefreshHeader(
              icon: Icon(CupertinoIcons.house_fill, color: Colors.grey),
            ),
            onRefresh: _onRefresh,
            child: ListView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              children: [
                HomeHeaderWidget(),
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
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
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

                if (state is HomeLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),

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

                if (state is HomeLoaded) ...[
                  ListView.builder(
                    physics:
                        NeverScrollableScrollPhysics(), // tránh scroll lồng nhau
                    shrinkWrap: true, // giúp list con chiếm chiều cao vừa đủ
                    itemCount: state.posts?.length,
                    itemBuilder: (context, index) {
                      final post = state.posts![index];
                      final commentCount = state.commentCounts?[post.id] ?? 0;
                      return PostItem(post: post, commentCount: commentCount);
                    },
                  ),

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
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
