import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_suggestion_item.dart';

class FriendSuggestionsPage extends StatefulWidget {
  const FriendSuggestionsPage({super.key});

  @override
  State<FriendSuggestionsPage> createState() => _FriendSuggestionsPageState();
}

class _FriendSuggestionsPageState extends State<FriendSuggestionsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    // Load tất cả gợi ý kết bạn khi khởi tạo
    context.read<FriendBloc>().add(const LoadFriendPage());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 200) return;

    final bloc = context.read<FriendBloc>();
    final currentState = bloc.state;

    bool hasMore = true;
    bool isLoadingMore = false;
    int nextPage = 1;

    if (currentState is FriendPageLoaded) {
      hasMore = currentState.hasMoreSuggestions;
      isLoadingMore = currentState.isLoadingMoreSuggestions;
      nextPage = currentState.suggestionPage + 1;
    } else if (currentState is FriendSuggestionsLoaded) {
      hasMore = currentState.hasMoreSuggestions;
      isLoadingMore = currentState.isLoadingMore;
      nextPage = currentState.suggestionPage + 1;
    } else {
      return;
    }

    if (!hasMore || isLoadingMore) return;

    bloc.add(LoadFriendSuggestions(page: nextPage, limit: 10, append: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
        ),
        title: Text(
          'Gợi ý',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            icon: Icon(CupertinoIcons.search, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            _buildHeaderSection(),

            // Danh sách gợi ý bạn bè
            Expanded(child: _buildFriendSuggestionsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        int suggestionCount = 0;

        if (state is FriendSuggestionsLoaded) {
          suggestionCount = state.friendSuggestions.length;
        } else if (state is FriendPageLoaded) {
          suggestionCount = state.friendSuggestions.length;
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            'Những người bạn có thể biết',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendSuggestionsList() {
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
        builder: (context, state) {
          if (state is FriendSuggestionsLoading ||
              (state is FriendPageLoaded && state.isLoadingSuggestions)) {
            return _buildLoadingState();
          } else if (state is FriendSuggestionsLoaded ||
              state is FriendPageLoaded) {
            final friendSuggestions = state is FriendSuggestionsLoaded
                ? state.friendSuggestions
                : (state as FriendPageLoaded).friendSuggestions;
            final sentRequestUserIds = state is FriendSuggestionsLoaded
                ? state.sentRequestUserIds
                : (state as FriendPageLoaded).sentRequestUserIds;

            if (friendSuggestions.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              backgroundColor: AppColors.background,
              color: AppColors.primary,
              onRefresh: () async {
                context.read<FriendBloc>().add(const LoadFriendPage());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount:
                    friendSuggestions.length + (_isLoadingMore(state) ? 1 : 0),
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  if (_isLoadingMore(state) &&
                      index == friendSuggestions.length) {
                    return _buildLoadMoreIndicator();
                  }
                  final suggestion = friendSuggestions[index];
                  return _buildFriendSuggestionCard(
                    suggestion,
                    sentRequestUserIds,
                  );
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
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Đang tải gợi ý...',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
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
            Icon(Icons.error_outline, size: 64.r, color: Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                context.read<FriendBloc>().add(const LoadFriendPage());
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
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

  Widget _buildFriendSuggestionCard(
    dynamic suggestion,
    Set<String> sentRequestUserIds,
  ) {
    final isSent = sentRequestUserIds.contains(suggestion.userId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FriendSuggestionItem(
        userId: suggestion.userId,
        name: suggestion.fullName ?? 'Người dùng',
        mutualFriends: suggestion.mutualFriends ?? 0,
        avatarUrl:
            suggestion.avatarUrl ??
            'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
        mutualFriendAvatars: suggestion.mutualFriendAvatars,
        isSent: isSent,
        onAddFriend: () {
          context.read<FriendBloc>().add(
            SendFriendRequest(receiverId: suggestion.userId),
          );
        },
        onRemove: () {
          context.read<FriendBloc>().add(
            RemoveFriendSuggestion(userId: suggestion.userId),
          );
        },
      ),
    );
  }

  bool _isLoadingMore(FriendState state) {
    if (state is FriendPageLoaded) return state.isLoadingMoreSuggestions;
    if (state is FriendSuggestionsLoaded) return state.isLoadingMore;
    return false;
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: SizedBox(
          width: 28.w,
          height: 28.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
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
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.person_2,
                      size: 64.r,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Không có gợi ý nào',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Hiện tại không có gợi ý kết bạn nào\ncho bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<FriendBloc>().add(const LoadFriendPage());
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Làm mới'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
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
}
