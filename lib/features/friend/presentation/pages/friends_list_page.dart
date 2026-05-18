import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:social_app_fe/features/friend/data/data_sources/friend_online_service.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_item.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key});

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  String _sortBy = 'name'; // 'name', 'recent', 'online'
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  FriendOnlineService? _onlineService;
  StreamSubscription<Map<String, FriendOnlineStatus>>?
  _friendsStatusSubscription;
  Map<String, FriendOnlineStatus> _friendsStatus = {};
  bool _hasInitializedFriendsStatus = false;
  late String userId;
  late String username;
  @override
  void initState() {
    super.initState();
    // Load danh sách bạn bè khi khởi tạo
    context.read<FriendBloc>().add(const LoadFriends());
    _initializeOnlineService();
  }

  Future<void> _initializeOnlineService() async {
    try {
      // Lấy thông tin user hiện tại
      final userData = await TokenStorage.getUserData();
      if (userData == null || !mounted) return;

      userId = userData['id']?.toString() ?? '';
      username =
          userData['username']?.toString() ??
          userData['fullName']?.toString() ??
          'User';

      if (userId.isEmpty) return;

      // Khởi tạo service
      final socketClient = s1<SocketClient>(instanceName: 'friendSocket');
      _onlineService = FriendOnlineService(socketClient);

      // Kết nối và lắng nghe
      _onlineService!.connect(userId, username);

      // Lắng nghe stream trạng thái bạn bè
      _friendsStatusSubscription = _onlineService!.friendsStatusStream.listen(
        (statusMap) {
          if (mounted) {
            setState(() {
              _friendsStatus = statusMap;
            });
          }
        },
        onError: (error) {
          debugPrint('Error in friends status stream: $error');
        },
      );
    } catch (e) {
      debugPrint('Error initializing online service: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _friendsStatusSubscription?.cancel();
    _onlineService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FriendBloc, FriendState>(
      listener: (context, state) {
        if (state is FriendActionSuccess) {
          _showMessage(context, state.message);
        } else if (state is FriendActionError) {
          _showMessage(context, state.message);
        }

        // Khởi tạo trạng thái bạn bè khi có danh sách mới
        if (state is FriendLoaded &&
            _onlineService != null &&
            !_hasInitializedFriendsStatus &&
            state.friends.isNotEmpty) {
          final friendIds = state.friends.map((f) => f.userId).toList();
          _onlineService!.initializeFriendsStatus(friendIds);
          _hasInitializedFriendsStatus = true;
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
            'Bạn bè',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.search, color: AppColors.textPrimary),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
          ],
        ),
        body: BlocBuilder<FriendBloc, FriendState>(
          builder: (context, state) {
            if (state is FriendLoading) {
              return Center(child: CircularProgressIndicator(color: AppColors.primary,));
            } else if (state is FriendLoaded) {
              final friends = state.friends;

              final filteredFriends = friends.where((f) {
                if (_searchQuery.isEmpty) return true;
                final q = _searchQuery.toLowerCase();
                final name = (f.fullName ?? '').toLowerCase();
                final username = (f.username ?? '').toLowerCase();
                return name.contains(q) || username.contains(q);
              }).toList();

              // Đếm số lượng bạn bè online từ status
              final onlineFriendsCount = _friendsStatus.values
                  .where((status) => status.isOnline)
                  .length;

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
                        hintText: 'Tìm kiếm bạn bè',
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
                              '${filteredFriends.length} bạn bè',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: _showSortOptions,
                              child: Text(
                                'Sắp xếp',
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
                          '$onlineFriendsCount người đang hoạt động',
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
                                  'Chưa có bạn bè nào',
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
                              // Lấy trạng thái online từ WebSocket
                              final friendStatus =
                                  _friendsStatus[friend.userId];

                              return FriendItem(
                                friendId: friend.userId,
                                name: friend.fullName ?? 'Người dùng',
                                mutualFriends: friend.mutualFriendsCount ?? 0,
                                avatarUrl: friend.avatarUrl,
                                mutualFriendAvatars: friend.mutualFriendAvatars,
                                isOnline: friendStatus?.isOnline,
                                lastSeen: friendStatus?.lastSeen,
                                onMyFriend: true,
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
                                  //         userId: userId,
                                  //         username: username,
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
                      'Lỗi tải dữ liệu',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FriendBloc>().add(const LoadFriends());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: const Text('Thử lại'),
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
                  'Sắp xếp theo',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildSortOption('Tên', 'name'),
                _buildSortOption('Gần đây', 'recent'),
                _buildSortOption('Đang hoạt động', 'online'),
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
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  String _formatFriendsSince(DateTime? friendsSince) {
    if (friendsSince == null) return 'Là bạn bè từ lâu';

    final months = [
      'tháng 1',
      'tháng 2',
      'tháng 3',
      'tháng 4',
      'tháng 5',
      'tháng 6',
      'tháng 7',
      'tháng 8',
      'tháng 9',
      'tháng 10',
      'tháng 11',
      'tháng 12',
    ];

    return 'Là bạn bè từ ${months[friendsSince.month - 1]} năm ${friendsSince.year}';
  }

  void _showMoreOptions(BuildContext context, dynamic friend) {
    final name = friend.fullName ?? 'Người dùng';
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
                              _formatFriendsSince(friendsSince),
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
                  title: 'Nhắn tin cho $name',
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage(context, 'Nhắn tin cho $name');
                  },
                  iconColor: AppColors.primary,
                ),
                _buildOptionItem(
                  icon: CupertinoIcons.person_badge_minus,
                  title: 'Hủy kết bạn với $name',
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
    final name = friend.fullName ?? 'Người dùng';
    final friendId = friend.userId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Hủy kết bạn',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18.sp),
        ),
        content: Text(
          'Bạn có chắc chắn muốn hủy kết bạn với $name?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: AppColors.textPrimary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Gọi RemoveFriend event với friendId
              context.read<FriendBloc>().add(RemoveFriend(friendId: friendId));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}
