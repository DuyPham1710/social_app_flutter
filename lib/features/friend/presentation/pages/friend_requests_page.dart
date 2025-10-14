import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_request_item.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  @override
  void initState() {
    super.initState();
    // Load tất cả lời mời kết bạn khi khởi tạo
    context.read<FriendBloc>().add(LoadFriendRequests(received: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Lời mời kết bạn',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchDialog(context);
            },
            icon: const Icon(
              CupertinoIcons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section với số lượng lời mời
            _buildHeaderSection(),
            
            // Danh sách lời mời kết bạn
            Expanded(
              child: _buildFriendRequestsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        int requestCount = 0;
        
        if (state is FriendRequestsLoaded) {
          requestCount = state.friendRequests.length;
        }
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Lời mời kết bạn',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '$requestCount',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _showSortOptions(context);
                },
                child: Text(
                  'Sắp xếp',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFriendRequestsList() {
    return BlocListener<FriendBloc, FriendState>(
      listener: (context, state) {
        if (state is FriendActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        } else if (state is FriendActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              action: SnackBarAction(
                label: 'Thử lại',
                textColor: Colors.white,
                onPressed: () {
                  context.read<FriendBloc>().add(const LoadFriendRequests(received: true));
                },
              ),
            ),
          );
        }
      },
      child: BlocBuilder<FriendBloc, FriendState>(
        builder: (context, state) {
          if (state is FriendRequestsLoading) {
            return _buildLoadingState();
          } else if (state is FriendRequestsLoaded) {
            if (state.friendRequests.isEmpty) {
              return _buildEmptyState();
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FriendBloc>().add(const LoadFriendRequests(received: true));
                await Future.delayed(const Duration(seconds: 1)); // Đảm bảo refresh indicator hiển thị
              },
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: state.friendRequests.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final request = state.friendRequests[index];
                  return _buildFriendRequestCard(request);
                },
              ),
            );
          } else if (state is FriendError) {
            return _buildErrorState(state.message);
          }
          
          return _buildLoadingState();
        },
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Đang tải lời mời kết bạn...',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
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
              'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                context.read<FriendBloc>().add(const LoadFriendRequests(received: true));
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFriendRequestCard(dynamic request) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FriendRequestItem(
        name: request.displayName,
        mutualFriends: request.displayMutualFriends,
        timeAgo: request.formattedTimeAgo,
        avatarUrl: request.displayAvatarUrl,
        mutualFriendAvatars: request.mutualFriendAvatars,
        onAccept: () {
          context.read<FriendBloc>().add(
            AcceptFriendRequest(requestId: request.requestId),
          );
        },
        onReject: () {
          context.read<FriendBloc>().add(
            RejectFriendRequest(requestId: request.requestId),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FriendBloc>().add(const LoadFriendRequests(received: true));
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.person_2,
                      size: 64.r,
                      color: Colors.blue[300],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Không có lời mời kết bạn nào',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Khi có người gửi lời mời kết bạn,\nbạn sẽ thấy chúng ở đây',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<FriendBloc>().add(const LoadFriendRequests(received: true));
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Làm mới'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Hiển thị dialog sắp xếp
  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Sắp xếp theo',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            _buildSortOption('Thời gian gần nhất', 'time', false),
            _buildSortOption('Thời gian xa nhất', 'time', true),
            _buildSortOption('Tên A-Z', 'name', true),
            _buildSortOption('Tên Z-A', 'name', false),
            _buildSortOption('Nhiều bạn chung nhất', 'mutualFriends', false),
            _buildSortOption('Ít bạn chung nhất', 'mutualFriends', true),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String sortBy, bool ascending) {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        bool isSelected = false;
        if (state is FriendRequestsLoaded) {
          isSelected = state.sortBy == sortBy && state.ascending == ascending;
        }
        
        return ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.blue[600] : Colors.black,
            ),
          ),
          trailing: isSelected ? Icon(
            Icons.check,
            color: Colors.blue[600],
            size: 20,
          ) : null,
          onTap: () {
            context.read<FriendBloc>().add(
              SortFriendRequests(sortBy: sortBy, ascending: ascending),
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  /// Hiển thị dialog tìm kiếm
  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    int? minMutualFriends;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tìm kiếm và lọc',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm theo tên hoặc username',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text(
                  'Bạn chung tối thiểu:',
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    value: minMutualFriends,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Tất cả')),
                      const DropdownMenuItem(value: 1, child: Text('1+')),
                      const DropdownMenuItem(value: 5, child: Text('5+')),
                      const DropdownMenuItem(value: 10, child: Text('10+')),
                      const DropdownMenuItem(value: 20, child: Text('20+')),
                    ],
                    onChanged: (value) => minMutualFriends = value,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FriendBloc>().add(
                FilterFriendRequests(
                  searchQuery: searchController.text.trim().isEmpty 
                      ? null 
                      : searchController.text.trim(),
                  minMutualFriends: minMutualFriends,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }


}
