import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/services/fcm_service.dart';
import 'package:social_app_fe/features/app/presentation/widgets/restart_widget.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/community/presentation/pages/community_page.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friends_list_page.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_event.dart';
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
import 'package:social_app_fe/features/profile/presentation/pages/privacy_security_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/appearance_settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  static const Duration _fadeDuration = Duration(milliseconds: 260);

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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider<MenuBloc>(
          create: (_) => s1<MenuBloc>(),
          child: Builder(
            builder: (blocContext) => AlertDialog(
              backgroundColor: AppColors.background,
              title: Text(
                'Đăng xuất khỏi tài khoản của bạn?',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18.sp),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await FcmService().clearFcmToken();
                    blocContext.read<MenuBloc>().add(LogoutEvent());
                    if (!mounted) return;
                    RestartWidget.restartApp(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ProfileMenuDrawer(onLogout: _showLogoutDialog),
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
          if (state is ProfileError && user == null) {
            return _fadeContent(
              key: 'profile-error',
              child: _buildErrorProfile(
                state.errorMessage ?? 'Không thể tải trang cá nhân',
              ),
            );
          }

          if (user == null) {
            return _fadeContent(
              key: 'profile-loading',
              child: _buildLoadingProfile(),
            );
          }
          return _fadeContent(
            key: 'profile-loaded-${user.userId}',
            child: RefreshIndicator(
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
                      Builder(
                        builder: (context) => IconButton(
                          tooltip: 'Menu',
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: AppColors.iconPrimary,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
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
                      _buildPostsSection(state, posts),
                    ]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _fadeContent({required String key, required Widget child}) {
    return AnimatedSwitcher(
      duration: _fadeDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(key: ValueKey(key), child: child),
    );
  }

  Widget _buildLoadingProfile() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
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
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const ProfileHeader(isLoading: true),
            const _ProfileActionSkeleton(),
            const Divider(),
            const _ProfileInfoSkeleton(),
            const Divider(),
            const _PostSkeletonList(),
          ]),
        ),
      ],
    );
  }

  Widget _buildErrorProfile(String message) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
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
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFE11D48),
                    size: 42,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 14.h),
                  OutlinedButton.icon(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostsSection(ProfileState state, List posts) {
    return Column(
      children: [
        if (state is ProfileLoading) const _PostSkeletonList(),
        if (state is ProfileError)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                state.errorMessage ?? "Không thể tải bài viết",
                style: const TextStyle(color: AppColors.textSecondary),
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
              child: CircularProgressIndicator(color: AppColors.primary),
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
      ],
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

class ProfileMenuDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileMenuDrawer({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemBgColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.02);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            Divider(color: AppColors.divider),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                children: [
                  _buildMenuButton(
                    context,
                    icon: Icons.bookmark_rounded,
                    iconColor: const Color(0xFF8B5CF6), // Purple
                    title: 'Đã lưu',
                    bgColor: itemBgColor,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedItemsPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    icon: Icons.groups_rounded,
                    iconColor: const Color(0xFF3B82F6), // Blue
                    title: 'Cộng đồng',
                    bgColor: itemBgColor,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CommunityPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    icon: Icons.brightness_medium_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Giao diện',
                    bgColor: itemBgColor,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppearanceSettingsPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    icon: Icons.security_rounded,
                    iconColor: const Color(0xFF10B981), // Green
                    title: 'Quyền riêng tư & bảo mật',
                    bgColor: itemBgColor,
                    onTap: () {
                      final profileBloc = context.read<ProfileBloc>();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: profileBloc,
                            child: const PrivacySecurityPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    icon: Icons.logout_rounded,
                    iconColor: Colors.redAccent,
                    title: 'Đăng xuất',
                    bgColor: itemBgColor,
                    onTap: () {
                      Navigator.pop(context);
                      onLogout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textSecondary.withOpacity(0.5),
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileActionSkeleton extends StatelessWidget {
  const _ProfileActionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: const [
          Expanded(child: _SkeletonBox(height: 38, radius: 10)),
          SizedBox(width: 10),
          _SkeletonBox(width: 44, height: 38, radius: 10),
        ],
      ),
    );
  }
}

class _ProfileInfoSkeleton extends StatelessWidget {
  const _ProfileInfoSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SkeletonBox(width: 210, height: 14, radius: 7),
          SizedBox(height: 10),
          _SkeletonBox(width: 160, height: 14, radius: 7),
          SizedBox(height: 10),
          _SkeletonBox(width: 190, height: 14, radius: 7),
        ],
      ),
    );
  }
}

class _PostSkeletonList extends StatelessWidget {
  const _PostSkeletonList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        children: List.generate(
          2,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE4E7EC)),
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
                          _SkeletonBox(width: 150, height: 14, radius: 7),
                          SizedBox(height: 8),
                          _SkeletonBox(width: 90, height: 12, radius: 6),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                const _SkeletonBox(
                  width: double.infinity,
                  height: 13,
                  radius: 7,
                ),
                SizedBox(height: 8.h),
                const _SkeletonBox(width: 230, height: 13, radius: 7),
              ],
            ),
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
