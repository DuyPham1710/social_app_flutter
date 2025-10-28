import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_item.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_actions.dart';
import '../widgets/profile_info.dart';
import '../widgets/friend_list_widget.dart';
import '../widgets/create_post_widget.dart';

class ProfilePage extends StatefulWidget {
  final String userId; //Truyền userId để biết profile của ai

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Khi vào trang -> load bài viết của user
    context.read<ProfileBloc>().add(
      LoadProfilePostsEvent(ownerId: widget.userId, page: 1, limit: 5),
    );
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
            slivers: [
              // Header
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                title: const Text(
                  'Nguyễn.H.N. Lam',
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
                    friends: [
                      {
                        "name": "Nguyễn Minh",
                        "avatarUrl": "https://i.pravatar.cc/150?img=11",
                      },
                      {
                        "name": "Trần Linh",
                        "avatarUrl": "https://i.pravatar.cc/150?img=12",
                      },
                      {
                        "name": "Nguyễn Minh",
                        "avatarUrl": "https://i.pravatar.cc/150?img=13",
                      },
                      {
                        "name": "Trần Linh",
                        "avatarUrl": "https://i.pravatar.cc/150?img=14",
                      },
                      {
                        "name": "Nguyễn Minh",
                        "avatarUrl": "https://i.pravatar.cc/150?img=15",
                      },
                      {
                        "name": "Trần Linh",
                        "avatarUrl": "https://i.pravatar.cc/150?img=16",
                      },
                    ],
                    onViewAll: () => Navigator.pushNamed(context, '/friends'),
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  CreatePostWidget(
                    avatarUrl: 'https://i.pravatar.cc/150?img=10',
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
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  if (state is ProfileLoaded)
                    ...posts.map((post) => PostItem(post: post)).toList(),

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
