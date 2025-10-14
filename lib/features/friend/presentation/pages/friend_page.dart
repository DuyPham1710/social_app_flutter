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
    context.read<FriendBloc>().add(LoadFriendRequests(received: true));
    context.read<FriendBloc>().add(LoadFriendSuggestions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.search),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FriendHeaderChips(),
              SizedBox(height: 16.h),

              // Lời mời kết bạn
              _buildSectionHeader(
                title: 'Lời mời kết bạn',
                trailing: 'Xem tất cả',
                onTapTrailing: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FriendRequestsPage(),
                    ),
                  );
                },
              ),
              SizedBox(height: 8.h),
              _buildFriendRequestsSection(),

              SizedBox(height: 20.h),

              // Những người bạn có thể biết
              _buildSectionHeader(
                title: 'Những người bạn có thể biết',
              ),
              SizedBox(height: 8.h),
              _buildFriendSuggestionsSection(),
            ],
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
            ),
          );
        }
      },
      child: BlocBuilder<FriendBloc, FriendState>(
        buildWhen: (previous, current) {
          // Chỉ rebuild khi state liên quan đến friend requests thay đổi
          return current is FriendRequestsLoading ||
                 current is FriendRequestsLoaded ||
                 (current is FriendError && previous is FriendRequestsLoading);
        },
        builder: (context, state) {
          if (state is FriendRequestsLoading) {
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
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is FriendRequestsLoaded) {
            if (state.friendRequests.isEmpty) {
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
                children: state.friendRequests.take(3).map((request) {
                  return FriendRequestItem(
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
                        context.read<FriendBloc>().add(const LoadFriendRequests(received: true));
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
          // Chỉ rebuild khi state liên quan đến friend suggestions thay đổi
          return current is FriendSuggestionsLoading ||
                 current is FriendSuggestionsLoaded ||
                 (current is FriendError && previous is FriendSuggestionsLoading);
        },
        builder: (context, state) {
        if (state is FriendSuggestionsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FriendSuggestionsLoaded) {
          return Column(
            children: state.friendSuggestions.map((suggestion) {
              return FriendSuggestionItem(
                name: suggestion.fullName ?? 'Người dùng',
                mutualFriends: suggestion.mutualFriends ?? 0,
                avatarUrl: suggestion.avatarUrl ?? 'https://i.pravatar.cc/150?img=30',
                mutualFriendAvatars: suggestion.mutualFriendAvatars,
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



