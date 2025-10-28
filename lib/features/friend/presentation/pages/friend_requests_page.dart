import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_request_item.dart';
import 'package:social_app_fe/features/friend/presentation/pages/sent_friend_requests_page.dart';

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
    context.read<FriendBloc>().add(const LoadFriendPage());
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
              _showMoreOptions(context);
            },
            icon: const Icon(
              Icons.more_vert,
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
      buildWhen: (previous, current) {
        // Chỉ rebuild khi state liên quan đến friend requests thay đổi
        return current is FriendRequestsLoaded || current is FriendPageLoaded;
      },
      builder: (context, state) {
        int requestCount = 0;
        
        if (state is FriendRequestsLoaded) {
          requestCount = state.friendRequests.length;
        } else if (state is FriendPageLoaded) {
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
                  context.read<FriendBloc>().add(const LoadFriendPage());
                },
              ),
            ),
          );
        }
      },
      child: BlocBuilder<FriendBloc, FriendState>(
        buildWhen: (previous, current) {
          // Chỉ rebuild khi state liên quan đến friend requests (received) thay đổi
          return current is FriendRequestsLoading ||
                 current is FriendRequestsLoaded ||
                 current is FriendPageLoaded ||
                 (current is FriendError && previous is FriendRequestsLoading);
        },
        builder: (context, state) {
          if (state is FriendRequestsLoading || (state is FriendPageLoaded && state.isLoadingRequests)) {
            return _buildLoadingState();
          } else if (state is FriendRequestsLoaded || state is FriendPageLoaded) {
            final friendRequests = state is FriendRequestsLoaded 
                ? state.friendRequests 
                : (state as FriendPageLoaded).friendRequests;
            final acceptedRequestIds = state is FriendRequestsLoaded 
                ? state.acceptedRequestIds 
                : (state as FriendPageLoaded).acceptedRequestIds;
            final rejectedRequestIds = state is FriendRequestsLoaded 
                ? state.rejectedRequestIds 
                : (state as FriendPageLoaded).rejectedRequestIds;
            
            if (friendRequests.isEmpty) {
              return _buildEmptyState();
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FriendBloc>().add(const LoadFriendPage());
                await Future.delayed(const Duration(seconds: 1)); // Đảm bảo refresh indicator hiển thị
              },
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: friendRequests.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final request = friendRequests[index];
                  return _buildFriendRequestCard(request, acceptedRequestIds, rejectedRequestIds);
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
                context.read<FriendBloc>().add(const LoadFriendPage());
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
  
  Widget _buildFriendRequestCard(dynamic request, Set<String> acceptedRequestIds, Set<String> rejectedRequestIds) {
    final isAccepted = acceptedRequestIds.contains(request.requestId);
    final isRejected = rejectedRequestIds.contains(request.requestId);

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
        isAccepted: isAccepted,
        isRejected: isRejected,
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
        context.read<FriendBloc>().add(const LoadFriendPage());
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
        } else if (state is FriendPageLoaded) {
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

  /// Hiển thị bottom modal với các tùy chọn
  void _showMoreOptions(BuildContext context) {
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
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            // Option: Xem lời mời đã gửi
            ListTile(
              leading: Icon(
                Icons.send_outlined,
                color: Colors.black,
                size: 24.r,
              ),
              title: Text(
                'Xem lời mời kết bạn đã gửi',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SentFriendRequestsPage(),
                  ),
                );
                // Reload lại friend requests khi quay về
                if (mounted) {
                  context.read<FriendBloc>().add(const LoadFriendPage());
                }
              },
            ),
            
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }


}

