import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_header_chips.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_request_item.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_suggestion_item.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friend_requests_page.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  void initState() {
    super.initState();
    // Load data khi khởi tạo
    _loadData();
  }

  void _loadData() {
    context.read<FriendBloc>().add(const LoadFriendPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text('Friend'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search)),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadData();
            // Đợi một chút để animation hoàn thành
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FriendHeaderChips(onNeedRefresh: _loadData),
                SizedBox(height: 16.h),

                // Lời mời kết bạn
                _buildSectionHeader(
                  title: 'Lời mời kết bạn',
                  trailing: 'Xem tất cả',
                  onTapTrailing: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FriendRequestsPage(),
                      ),
                    );
                    // Reload data khi quay lại từ trang chi tiết
                    if (mounted) {
                      _loadData();
                    }
                  },
                ),
                SizedBox(height: 8.h),
                _buildFriendRequestsSection(),

                SizedBox(height: 20.h),

                // Những người bạn có thể biết
                _buildSectionHeader(title: 'Những người bạn có thể biết'),
                SizedBox(height: 8.h),
                _buildFriendSuggestionsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendRequestsSection() {
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
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
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
            ),
          );
        }
      },
      child: BlocBuilder<FriendBloc, FriendState>(
        buildWhen: (previous, current) {
          // Rebuild khi có FriendPageLoaded hoặc các state liên quan đến friend requests
          return current is FriendPageLoaded ||
              current is FriendRequestsLoading ||
              current is FriendRequestsLoaded ||
              (current is FriendError && previous is FriendRequestsLoading);
        },
        builder: (context, state) {
          if (state is FriendRequestsLoading ||
              (state is FriendPageLoaded && state.isLoadingRequests)) {
            return Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is FriendRequestsLoaded ||
              state is FriendPageLoaded) {
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
              return Container(
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.person_2,
                        size: 32.r,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Không có lời mời kết bạn nào',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Hiển thị tối đa 3 lời mời đầu tiên
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: friendRequests.take(3).map((request) {
                  final isAccepted = acceptedRequestIds.contains(
                    request.requestId,
                  );
                  final isRejected = rejectedRequestIds.contains(
                    request.requestId,
                  );
                  return FriendRequestItem(
                    userId: request.senderId,
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
                  );
                }).toList(),
              ),
            );
          } else if (state is FriendError) {
            return Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 32.r,
                      color: Colors.red[300],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Lỗi tải dữ liệu',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    TextButton(
                      onPressed: () {
                        context.read<FriendBloc>().add(const LoadFriendPage());
                      },
                      child: Text(
                        'Thử lại',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFriendSuggestionsSection() {
    return BlocListener<FriendBloc, FriendState>(
      listener: (context, state) {
        if (state is FriendActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is FriendActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: BlocBuilder<FriendBloc, FriendState>(
        buildWhen: (previous, current) {
          // Rebuild khi có FriendPageLoaded hoặc các state liên quan đến friend suggestions
          return current is FriendPageLoaded ||
              current is FriendSuggestionsLoading ||
              current is FriendSuggestionsLoaded ||
              current is FriendActionSuccess ||
              current is FriendActionError ||
              (current is FriendError && previous is FriendSuggestionsLoading);
        },
        builder: (context, state) {
          if (state is FriendSuggestionsLoading ||
              (state is FriendPageLoaded && state.isLoadingSuggestions)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FriendSuggestionsLoaded ||
              state is FriendPageLoaded) {
            final friendSuggestions = state is FriendSuggestionsLoaded
                ? state.friendSuggestions
                : (state as FriendPageLoaded).friendSuggestions;
            final sentRequestUserIds = state is FriendSuggestionsLoaded
                ? state.sentRequestUserIds
                : (state as FriendPageLoaded).sentRequestUserIds;

            return Column(
              children: friendSuggestions.map((suggestion) {
                final isSent = sentRequestUserIds.contains(suggestion.userId);
                return FriendSuggestionItem(
                  userId: suggestion.userId,
                  name: suggestion.fullName ?? 'Người dùng',
                  mutualFriends: suggestion.mutualFriends ?? 0,
                  avatarUrl:
                      suggestion.avatarUrl ??
                      'https://i.pravatar.cc/150?img=30',
                  mutualFriendAvatars: suggestion.mutualFriendAvatars,
                  isSent: isSent,
                  onAddFriend: () {
                    context.read<FriendBloc>().add(
                      SendFriendRequest(receiverId: suggestion.userId),
                    );
                  },
                );
              }).toList(),
            );
          } else if (state is FriendError) {
            return Column(
              children: List.generate(
                3,
                (index) => FriendSuggestionItem(
                  userId: "68e9d3fa7ae32fe700d1d3cc",
                  name: 'Người dùng ${index + 1}',
                  mutualFriends: 5 + index,
                  avatarUrl: 'https://i.pravatar.cc/150?img=${index + 10}',
                  onAddFriend: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chức năng đang được phát triển'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? trailing,
    VoidCallback? onTapTrailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTapTrailing,
            child: Text(
              trailing,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
