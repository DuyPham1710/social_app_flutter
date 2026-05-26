import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_for_user_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/utils/friend_l10n_helper.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class FriendForUserPage extends StatefulWidget {
  final String userId;
  final String username;
  final String fullName;
  const FriendForUserPage({
    super.key,
    required this.userId,
    required this.username,
    required this.fullName,
  });

  @override
  State<FriendForUserPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendForUserPage> {
  String _sortBy = 'name'; // 'name', 'recent', 'online'
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load danh sách bạn bè khi khởi tạo
    context.read<FriendForUserBloc>().add(LoadFriendsByUserId(widget.userId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FriendForUserBloc, FriendForUserState>(
      listener: (context, state) {
        if (state is FriendActionSuccess) {
          _showMessage(context, state.message);
        } else if (state is FriendActionError) {
          _showMessage(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.l10n.friendFriendsOf(
              widget.fullName.trim().split(" ").last,
            ),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.search, color: AppColors.textPrimary),
              onPressed: _showSearch,
            ),
          ],
        ),
        body: BlocBuilder<FriendForUserBloc, FriendForUserState>(
          builder: (context, state) {
            if (state is FriendLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FriendLoaded) {
              final friends = state.friends;
              final filteredFriends = friends.where((f) {
                if (_searchQuery.isEmpty) return true;
                final q = _searchQuery.toLowerCase();
                final name = (f.fullName ?? '').toLowerCase();
                final username = (f.username ?? '').toLowerCase();
                return name.contains(q) || username.contains(q);
              }).toList();
              final onlineFriendsCount =
                  50; // Tạm thời hardcode, sau có thể lấy từ API

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                      cursorColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: context.l10n.friendSearchHint,
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppColors.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        fillColor: AppColors.secondBackground,
                        filled: true,
                      ),
                    ),
                  ),
                  // Header section
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.divider, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.friendCount(filteredFriends.length),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: _showSortOptions,
                              child: Text(
                                context.l10n.friendSort,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.l10n.friendActiveCount(onlineFriendsCount),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Friends list
                  Expanded(
                    child: filteredFriends.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.person_2,
                                  size: 64.r,
                                  color: AppColors.unselectedIcon,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  context.l10n.friendNoFriends,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredFriends.length,
                            itemBuilder: (context, index) {
                              final friend = filteredFriends[index];
                              return FriendItem(
                                friendId: friend.userId,
                                name:
                                    friend.fullName ?? context.l10n.commonUser,
                                mutualFriends: friend.mutualFriendsCount ?? 0,
                                avatarUrl: friend.avatarUrl,
                                mutualFriendAvatars: friend.mutualFriendAvatars,
                                onMyFriend: false,
                                onMessage: () {
                                  // final messageBloc = s1<MessageBloc>();

                                  // UserEntity friendInfo = UserEntity(
                                  //   userId: friend.userId,
                                  //   username: friend.username,
                                  //   fullName: friend.fullName,
                                  //   avatarUrl: friend.avatarUrl,
                                  // );
                                  // Navigator.push(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (_) => BlocProvider(
                                  //       create: (_) => messageBloc,
                                  //       child: ChatDetailPage(
                                  //         // Pass friendId to create new conversation
                                  //         userId: widget.userId,
                                  //         username: widget.username,
                                  //         friendId: friend.userId,
                                  //         friendInfo: friendInfo,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // );
                                },
                                onMoreOptions: () {
                                  _showMoreOptions(context, friend);
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            } else if (state is FriendError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.r,
                      color: Colors.red[300],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      context.l10n.friendLoadDataError,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      localizedFriendActionMessage(context.l10n, state.message),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FriendForUserBloc>().add(
                          const LoadFriends(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(context.l10n.commonRetry),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showSearch() {
    // TODO: Implement search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.commonFeatureInDevelopment),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.friendSortBy,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildSortOption(context.l10n.friendSortName, 'name'),
                _buildSortOption(context.l10n.friendSortRecent, 'recent'),
                _buildSortOption(context.l10n.friendSortOnline, 'online'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, String value) {
    final isSelected = _sortBy == value;
    return InkWell(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
        // TODO: Implement actual sorting logic
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: AppColors.primary, size: 24.r),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizedFriendActionMessage(context.l10n, message)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatFriendsSince(BuildContext context, DateTime? friendsSince) {
    if (friendsSince == null) return context.l10n.friendLongtimeFriend;

    return context.l10n.friendFriendsSince(
      context.l10n.monthName(friendsSince.month),
      friendsSince.year,
    );
  }

  void _showMoreOptions(BuildContext context, dynamic friend) {
    final name = friend.fullName ?? context.l10n.commonUser;
    final avatarUrl =
        friend.avatarUrl ??
        'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg';
    final friendsSince = friend.friendsSince as DateTime?;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                // Friend info header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundImage: NetworkImage(avatarUrl),
                        backgroundColor: AppColors.divider,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _formatFriendsSince(context, friendsSince),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(height: 1, color: AppColors.divider),
                SizedBox(height: 8.h),
                _buildOptionItem(
                  icon: CupertinoIcons.chat_bubble_fill,
                  title: context.l10n.friendMessageUser(name),
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage(context, context.l10n.friendMessageUser(name));
                  },
                  iconColor: AppColors.primary,
                ),
                _buildOptionItem(
                  icon: CupertinoIcons.person_badge_minus,
                  title: context.l10n.friendUnfriendUser(name),
                  onTap: () {
                    Navigator.pop(context);
                    _showUnfriendDialog(friend);
                  },
                  isDestructive: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  iconColor ??
                  (isDestructive ? Colors.red : AppColors.textSecondary),
              size: 24.r,
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: isDestructive ? Colors.red : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnfriendDialog(dynamic friend) {
    final name = friend.fullName ?? context.l10n.commonUser;
    final friendId = friend.userId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(context.l10n.friendUnfriendTitle),
        content: Text(context.l10n.friendUnfriendConfirm(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Gọi RemoveFriend event với friendId
              context.read<FriendForUserBloc>().add(
                RemoveFriend(friendId: friendId),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(context.l10n.commonConfirm),
          ),
        ],
      ),
    );
  }
}
