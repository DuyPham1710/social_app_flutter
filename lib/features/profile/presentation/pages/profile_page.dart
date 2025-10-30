import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_item.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_state.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
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
    context.read<ProfileBloc>().add(const LoadProfilePostsEvent());
    context.read<FriendBloc>().add(const LoadFriends());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Lỗi tải bài viết')),
            );
          }
        },
        builder: (context, state) {
          final posts = state.posts ?? [];

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                title: Text(
                  //lấy tên người dùng từ storage
                  'Trang cá nhân',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                actions: const [
                  Icon(Icons.settings_outlined, color: AppColors.textPrimary),
                  SizedBox(width: 12),
                  Icon(Icons.search, color: AppColors.iconPrimary),
                  SizedBox(width: 8),
                ],
              ),

              // Nội dung
              SliverList(
                delegate: SliverChildListDelegate([
                  const ProfileHeader(),
                  const ProfileActions(),
                  const ProfileInfo(),
                  const Divider(),
                  FriendListWidget(
                    onViewAll: () => Navigator.pushNamed(context, '/friends'),
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  CreatePostWidget(
                    avatarUrl: 'https://i.pravatar.cc/150?img=5',
                    onCreatePost: () =>
                        Navigator.pushNamed(context, '/create_post'),
                  ),
                  const Divider(),

                  // Trạng thái loading / lỗi / bài viết
                  if (state is ProfileLoading)
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
                    }).toList(),

                  if (state is ProfileLoaded && state.isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                  if (state is ProfileLoaded && state.hasNext == false)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: Text(
                          "Đã hiển thị hết bài viết",
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      ),
                    ),

                  if (state is ProfileLoaded && posts.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Center(
                        child: Text(
                          "Chưa có bài viết nào",
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      ),
                    ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
