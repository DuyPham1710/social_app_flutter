import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';

class TagFriendsPage extends StatefulWidget {
  final List<String> initialSelectedFriends;
  const TagFriendsPage({super.key, this.initialSelectedFriends = const []});

  @override
  State<TagFriendsPage> createState() => _TagFriendsPageState();
}

class _TagFriendsPageState extends State<TagFriendsPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    context.read<FriendBloc>().add(LoadFriends());
    _selectedIds.addAll(widget.initialSelectedFriends);
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        List<Map<String, String>> allFriends = [];

        if (state is FriendLoaded) {
          allFriends = state.friends
              .map(
                (f) => {
                  'id': f.userId,
                  'name': f.fullName ?? f.username ?? 'Unknown',
                  'avatar':
                      f.avatarUrl ??
                      'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                },
              )
              .toList();
        }

        final query = _searchController.text.toLowerCase();
        final filteredFriends = allFriends
            .where((friend) => friend['name']!.toLowerCase().contains(query))
            .toList();

        final selectedFriends = allFriends
            .where((f) => _selectedIds.contains(f['id']))
            .toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.textPrimary,
                size: 20.sp,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Gắn thẻ người khác',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, selectedFriends);
                },
                child: Text(
                  'Xong',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          body: _buildBody(state, filteredFriends, selectedFriends),
        );
      },
    );
  }

  Widget _buildBody(
    FriendState state,
    List<Map<String, String>> filteredFriends,
    List<Map<String, String>> selectedFriends,
  ) {
    if (state is FriendLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    } else if (state is FriendError) {
      return Center(
        child: Text(
          'Lỗi tải bạn bè: ${state.message}',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 16.sp),
        ),
      );
    } else if (state is FriendLoaded) {
      return Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm bạn bè...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                        size: 18.sp,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Selected Chips
          if (selectedFriends.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              width: double.infinity,
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: selectedFriends.map((friend) {
                  return Chip(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(friend['avatar']!),
                    ),
                    label: Text(
                      friend['name']!.split(' ').last,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                    deleteIcon: Icon(
                      Icons.close,
                      color: AppColors.primary,
                      size: 16.sp,
                    ),
                    onDeleted: () => _toggleSelection(friend['id']!),
                  );
                }).toList(),
              ),
            ),

          Divider(height: 1.h, color: AppColors.divider),

          // Friends List
          Expanded(
            child: ListView.builder(
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                final isSelected = _selectedIds.contains(friend['id']);

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  leading: CircleAvatar(
                    radius: 22.r,
                    backgroundImage: NetworkImage(friend['avatar']!),
                  ),
                  title: Text(
                    friend['name']!,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary.withOpacity(0.5),
                        width: isSelected ? 0 : 1.5,
                      ),
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                        : null,
                  ),
                  onTap: () => _toggleSelection(friend['id']!),
                );
              },
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
