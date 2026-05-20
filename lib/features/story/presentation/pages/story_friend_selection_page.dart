import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';

class StoryFriendSelectionPage extends StatefulWidget {
  final List<String> initialSelectedIds;
  final String title;
  final bool allowEmptySelection;

  const StoryFriendSelectionPage({
    super.key,
    this.initialSelectedIds = const [],
    this.title = "Ẩn tin với",
    this.allowEmptySelection = false,
  });

  @override
  State<StoryFriendSelectionPage> createState() =>
      _StoryFriendSelectionPageState();
}

class _StoryFriendSelectionPageState extends State<StoryFriendSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedFriendIds = {};

  @override
  void initState() {
    super.initState();
    _selectedFriendIds.addAll(widget.initialSelectedIds);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    // Load danh sách bạn bè
    context.read<FriendBloc>().add(const LoadFriends());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelection(String friendId) {
    setState(() {
      if (_selectedFriendIds.contains(friendId)) {
        _selectedFriendIds.remove(friendId);
      } else {
        _selectedFriendIds.add(friendId);
      }
    });
  }

  void _onDone() {
    Navigator.of(context).pop(_selectedFriendIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.iconPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed:
                (!widget.allowEmptySelection && _selectedFriendIds.isEmpty)
                ? null
                : _onDone,
            child: Text(
              "Xong",
              style: TextStyle(
                color:
                    (!widget.allowEmptySelection && _selectedFriendIds.isEmpty)
                    ? AppColors.textSecondary.withOpacity(0.5)
                    : AppColors.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondBackground,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: _searchController,
                cursorColor: AppColors.primary,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: "Tìm kiếm",
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.iconPrimary,
                            size: 20.sp,
                          ),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),
          // Friends list
          Expanded(
            child: BlocBuilder<FriendBloc, FriendState>(
              builder: (context, state) {
                if (state is FriendLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is FriendLoaded) {
                  final friends = state.friends;
                  final filteredFriends = friends.where((f) {
                    if (_searchQuery.isEmpty) return true;
                    final q = _searchQuery;
                    final name = (f.fullName ?? '').toLowerCase();
                    final username = (f.username ?? '').toLowerCase();
                    return name.contains(q) || username.contains(q);
                  }).toList();

                  if (filteredFriends.isEmpty) {
                    return Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? "Chưa có bạn bè"
                            : "Không tìm thấy bạn bè",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredFriends.length,
                    itemBuilder: (context, index) {
                      final friend = filteredFriends[index];
                      final isSelected = _selectedFriendIds.contains(
                        friend.userId,
                      );
                      return _buildFriendItem(friend, isSelected);
                    },
                  );
                } else if (state is FriendError) {
                  return Center(
                    child: Text(
                      "Lỗi khi tải danh sách bạn bè",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendItem(FriendEntity friend, bool isSelected) {
    final name = friend.fullName ?? friend.username ?? 'Người dùng';
    final avatarUrl = friend.avatarUrl;

    return InkWell(
      onTap: () => _toggleSelection(friend.userId),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: AppColors.secondBackground,
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null || avatarUrl.isEmpty
                      ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
                if (isSelected)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            // Name
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Checkbox
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
