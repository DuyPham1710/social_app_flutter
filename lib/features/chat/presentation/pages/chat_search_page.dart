import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_suggestion_entity.dart';
import 'package:social_app_fe/features/friend/data/models/friend_model.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/chat_search/chat_search_bloc.dart';
import 'package:social_app_fe/features/chat/data/services/recent_search_service.dart';
import 'package:social_app_fe/features/chat/presentation/pages/recent_search_management_page.dart';

class ChatSearchPage extends StatefulWidget {
  final List<FriendEntity> friends;
  final Future<void> Function(FriendEntity)? onNavigateToChat;

  const ChatSearchPage({
    super.key,
    this.friends = const [],
    this.onNavigateToChat,
  });

  @override
  State<ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> {
  final TextEditingController _controller = TextEditingController();

  late ChatSearchBloc _chatSearchBloc;
  late RecentSearchService _recentSearchService;
  List<Map<String, dynamic>> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    // Khởi tạo services
    _chatSearchBloc = s1<ChatSearchBloc>();
    _recentSearchService = s1<RecentSearchService>();

    // Load friend suggestions cho section "Những người bạn có thể biết"
    _chatSearchBloc.add(const LoadFriendSuggestions(page: 1, limit: 4));

    // Load recent searches từ SharedPreferences
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final recentSearches = await _recentSearchService.getRecentSearches();
    if (mounted) {
      setState(() {
        _recentSearches = recentSearches;
      });
    }
  }

  @override
  void dispose() {
    _chatSearchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 0.9.sh,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),

        child: Column(
          children: [
            SizedBox(height: 40.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      controller: _controller,
                      cursorColor: AppColors.primary,
                      placeholder: "Tìm kiếm",
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      "Huỷ",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            Expanded(
              child: _controller.text.isEmpty
                  ? _buildSearchContent()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tìm kiếm gần đây",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),

            GestureDetector(
              onTap: () async {
                // Navigate to recent searches management page
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecentSearchManagementPage(),
                  ),
                );
                // Reload recent searches when coming back
                await _loadRecentSearches();
              },
              child: Text(
                "Chỉnh sửa",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        if (_recentSearches.isEmpty)
          Text(
            "Chưa có tìm kiếm gần đây",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
          )
        else
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: _recentSearches
                .take(10) // Chỉ hiển thị tối đa 10 recent searches
                .map(
                  (searchData) => _buildCircleUser(
                    userId: searchData['userId'],
                    username: searchData['username'],
                    fullName: searchData['fullName'],
                    avatarUrl: searchData['avatarUrl'],
                  ),
                )
                .toList(),
          ),

        SizedBox(height: 20.h),
        Text(
          "Gợi ý",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),

        Column(
          children: widget.friends
              .take(20) // Chỉ lấy 20 bạn bè đầu tiên
              .map((e) => _buildUserTile(e))
              .toList(),
        ),

        SizedBox(height: 20.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Những người bạn có thể biết",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),

            Text(
              "Xem thêm",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        BlocBuilder<ChatSearchBloc, ChatSearchState>(
          bloc: _chatSearchBloc,
          builder: (context, state) {
            if (state is ChatSearchLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            } else if (state is ChatSearchLoaded) {
              if (state.suggestions.isEmpty) {
                return Text(
                  "Hiện chưa có gợi ý bạn bè",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                  ),
                );
              }
              return Column(
                children: state.suggestions
                    .map(
                      (s) => _buildSuggestionTile(
                        s,
                        isSent: state.sentRequestUserIds.contains(s.userId),
                      ),
                    )
                    .toList(),
              );
            } else if (state is ChatSearchError) {
              return Text(
                state.message,
                style: TextStyle(color: Colors.red, fontSize: 13.sp),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final results = widget.friends
        .where(
          (e) =>
              e.fullName != null &&
              e.fullName!.toLowerCase().contains(
                _controller.text.toLowerCase(),
              ),
        )
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          "Không tìm thấy kết quả",
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: results.map((e) => _buildUserTile(e)).toList(),
    );
  }

  Widget _buildCircleUser({
    required String userId,
    required String? username,
    required String? fullName,
    String? avatarUrl,
  }) {
    return GestureDetector(
      onTap: () async {
        // Tạo FriendEntity từ recent search data
        final friend = FriendModel(
          userId: userId,
          fullName: fullName,
          username: username,
          avatarUrl: avatarUrl,
        );

        // Navigate đến chat với user này
        widget.onNavigateToChat?.call(friend);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : null,
            child: avatarUrl == null || avatarUrl.isEmpty
                ? Text(
                    (fullName?.isNotEmpty == true)
                        ? fullName![0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  )
                : null,
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: 60.w,
            child: Text(
              fullName ?? username ?? 'Unknown',
              style: TextStyle(fontSize: 12.sp),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(FriendEntity friend) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: friend.avatarUrl != null
            ? NetworkImage(friend.avatarUrl!)
            : null,
        radius: 22.r,
        backgroundColor: Colors.grey.shade300,
      ),
      title: Text(
        friend.fullName ?? 'Unknown',
        style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
      ),
      onTap: () async {
        // Navigate đến chat với user này
        widget.onNavigateToChat?.call(friend);
        // Lưu vào recent searches khi bấm vào user
        await _recentSearchService.saveRecentSearch(friend);
        // Reload recent searches để cập nhật UI
        await _loadRecentSearches();
      },
    );
  }

  Widget _buildSuggestionTile(
    FriendSuggestionEntity suggestion, {
    bool isSent = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 22.r,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: suggestion.avatarUrl != null
            ? NetworkImage(suggestion.avatarUrl!)
            : null,
      ),
      title: Text(
        // khi tên quá dài thì hiện ... sau
        suggestion.fullName ?? suggestion.username ?? 'Unknown',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
      ),
      subtitle:
          suggestion.mutualFriends != null && suggestion.mutualFriends! > 0
          ? Text(
              "${suggestion.mutualFriends} bạn chung",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
            )
          : null,
      trailing: _buildAddFriendButton(suggestion, isSent: isSent),
      onTap: () {
        // TODO: mở profile người dùng nếu cần
      },
    );
  }

  Widget _buildAddFriendButton(
    FriendSuggestionEntity suggestion, {
    required bool isSent,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isSent) {
          _chatSearchBloc.add(
            SendFriendRequestFromSearch(receiverId: suggestion.userId),
          );
        } else {
          _chatSearchBloc.add(
            CancelFriendRequestFromSearch(userId: suggestion.userId),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSent ? Colors.grey[200] : AppColors.primary,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: isSent
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.person_badge_minus,
                    color: AppColors.textSecondary,
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Hủy lời mời',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                'Thêm bạn bè',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
