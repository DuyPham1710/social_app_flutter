import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friends_list_page.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_state.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:social_app_fe/features/save/presentation/pages/saved_items_page.dart';
import 'package:social_app_fe/features/search/presentation/pages/search_page.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_actions.dart';
import '../widgets/profile_info.dart';
import '../widgets/friend_list_widget.dart';
import '../widgets/create_post_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProfileBloc>().add(const LoadMoreProfilePostsEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<ProfileBloc>().add(const LoadUserProfileEvent());
    context.read<FriendProfileBloc>().add(const LoadFriends());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Lỗi tải bài viết')));
          }
        },
        builder: (context, state) {
          final posts = state.posts ?? [];
          final UserEntity? user = state.user;
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return RefreshIndicator(
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
                // Header
                SliverAppBar(
                  surfaceTintColor: Colors.transparent,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  title: Text(
                    'Trang cá nhân',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: AppColors.iconPrimary,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SavedItemsPage(),
                          ),
                        );
                      },
                    ),
                    const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: AppColors.iconPrimary,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // Nội dung
                SliverList(
                  delegate: SliverChildListDelegate([
                    ProfileHeader(user: user, isLoading: state.isUserLoading),
                    ProfileActions(
                      onTapEdit: () async {
                        // 1. Lấy instance của ProfileBloc hiện tại TRƯỚC khi chuyển trang
                        final profileBloc = context.read<ProfileBloc>();

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: profileBloc,
                              child: ProfileEditPage(user: user),
                            ),
                          ),
                        );
                        if (context.mounted) {
                          context.read<ProfileBloc>().add(
                            const LoadUserProfileEvent(),
                          );
                        }
                      },
                    ),
                    ProfileInfo(user: user),
                    const Divider(),
                    FriendListWidget(
                      onViewAll: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FriendsListPage(),
                          ),
                        );
                        _loadData();
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 12),

                    CreatePostWidget(
                      avatarUrl: user.avatarUrl,
                      onCreatePost: () => _handleOpenCreatePost(),
                    ),
                    const Divider(),

                    // Trạng thái loading / lỗi / bài viết
                    if (state is ProfileLoading && state.user == null)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                    if (state is ProfileError)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            state.errorMessage ?? "Không thể tải bài viết",
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),

                    if (state is ProfileLoaded)
                      ...posts.map((post) {
                        final commentCount = state.commentCounts?[post.id] ?? 0;
                        return PostItem(post: post, commentCount: commentCount);
                      }),

                    if (state is ProfileLoaded && state.isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                    if (state is ProfileLoaded &&
                        state.hasNext == false &&
                        posts.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Center(
                          child: Text(
                            "Đã hiển thị hết bài viết",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),

                    if (state is ProfileLoaded && posts.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Center(
                          child: Text(
                            "Chưa có bài viết nào",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleOpenCreatePost() async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      '/main',
      (route) => false,
      arguments: {'initialTab': 2},
    );
  }
}
