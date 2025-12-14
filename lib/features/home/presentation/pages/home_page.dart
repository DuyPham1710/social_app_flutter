import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
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
import 'package:social_app_fe/features/video_call/presentation/bloc/bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Chỉ khởi tạo WebSocket, việc load posts sẽ được tự động trigger
    // sau khi WebSocket connect xong
    _connectVideoCall();
    context.read<HomeBloc>().add(const InitializeWebSocketEvent());

    // Lắng nghe sự kiện scroll để load more
    _scrollController.addListener(_onScroll);
  }

  Future<void> _connectVideoCall() async {
    final userData = await TokenStorage.getUserData();
    String userId = userData?['id'];
    String username = userData?['username'];
    context.read<VideoCallBloc>().add(
      ConnectVideoCall(userId: userId, username: username),
    );
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            backgroundColor: AppColors.background,
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
