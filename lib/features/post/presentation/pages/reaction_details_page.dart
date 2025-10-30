import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';

class ReactionDetailsPage extends StatefulWidget {
  final List<ReactPostEntity> reacts;
  final String postId;
  const ReactionDetailsPage({
    super.key,
    required this.reacts,
    required this.postId,
  });

  @override
  State<ReactionDetailsPage> createState() => _ReactionDetailsPageState();
}

class _ReactionDetailsPageState extends State<ReactionDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ReactPostEntity> _filteredReacts;
  EmojiType? _selectedEmoji;
  final Set<String> _sentFriendRequestUserIds = <String>{};

  @override
  void initState() {
    super.initState();

    // Sắp xếp theo thời gian react (mới nhất trước)
    _filteredReacts = List.from(widget.reacts)
      ..sort(
        (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
          a.createdAt ?? DateTime.now(),
        ),
      );

    // Tính số lượng tab (Tất cả + các emoji có người react)
    final emojiCounts = <EmojiType, int>{};
    for (var react in widget.reacts) {
      emojiCounts[react.emoji] = (emojiCounts[react.emoji] ?? 0) + 1;
    }

    // Tạo TabController với số tab = 1 (Tất cả) + số emoji unique
    _tabController = TabController(
      length: emojiCounts.keys.length + 1,
      vsync: this,
    );

    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      if (_tabController.index == 0) {
        // Tab "Tất cả"
        _selectedEmoji = null;
        _filteredReacts = List.from(widget.reacts)
          ..sort(
            (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
              a.createdAt ?? DateTime.now(),
            ),
          );
      } else {
        // Tab emoji cụ thể
        final emojiTypes = _getUniqueEmojis();
        _selectedEmoji = emojiTypes[_tabController.index - 1];
        _filteredReacts =
            widget.reacts
                .where((react) => react.emoji == _selectedEmoji)
                .toList()
              ..sort(
                (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
                  a.createdAt ?? DateTime.now(),
                ),
              );
      }
    });
  }

  List<EmojiType> _getUniqueEmojis() {
    final emojiCounts = <EmojiType, int>{};
    for (var react in widget.reacts) {
      emojiCounts[react.emoji] = (emojiCounts[react.emoji] ?? 0) + 1;
    }

    // Sắp xếp theo số lượng (nhiều nhất trước)
    final sortedEmojis = emojiCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEmojis.map((e) => e.key).toList();
  }

  int _getEmojiCount(EmojiType emoji) {
    return widget.reacts.where((react) => react.emoji == emoji).length;
  }

  @override
  Widget build(BuildContext context) {
    final uniqueEmojis = _getUniqueEmojis();
    final totalCount = widget.reacts.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Người đã bày tỏ cảm xúc',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.search, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
          dividerColor: AppColors.divider,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: [
            // Tab "Tất cả"
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tất cả', style: TextStyle(fontSize: 14.sp)),

                  SizedBox(width: 8.w),

                  Text(
                    totalCount.toString(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Tabs cho từng emoji
            ...uniqueEmojis.map((emoji) {
              final count = _getEmojiCount(emoji);
              return Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji.icon, style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 8.w),
                    Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab "Tất cả"
          _buildReactsList(_filteredReacts),

          // Tabs cho từng emoji
          ...uniqueEmojis.map((emoji) {
            final emojiReacts =
                widget.reacts.where((react) => react.emoji == emoji).toList()
                  ..sort(
                    (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
                      a.createdAt ?? DateTime.now(),
                    ),
                  );
            return _buildReactsList(emojiReacts);
          }),
        ],
      ),
    );
  }

  Widget _buildReactsList(List<ReactPostEntity> reacts) {
    if (reacts.isEmpty) {
      return Center(
        child: Text(
          'Chưa có ai bày tỏ cảm xúc',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: reacts.length,
      itemBuilder: (context, index) {
        final react = reacts[index];
        return _buildReactItem(react);
      },
    );
  }

  Widget _buildReactItem(ReactPostEntity react) {
    final bool showMutualFriends = (react.mutualFriendsCount ?? 0) > 0;
    final bool isSend = _sentFriendRequestUserIds.contains(react.user.userId);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          // Avatar với emoji
          Stack(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: NetworkImage(
                  react.user.avatarUrl ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
                ),

                backgroundColor: AppColors.background,

                child: react.user.avatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                        size: 22.sp,
                      )
                    : null,
              ),

              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      react.emoji.icon,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 12.w),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: showMutualFriends
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Text(
                  react.user.fullName ?? react.user.username ?? 'Unknown',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (showMutualFriends) ...[
                  SizedBox(height: 2.h),
                  Text(
                    '${react.mutualFriendsCount} bạn chung',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Action button (Thêm bạn bè/Nhắc đến)
          if (showMutualFriends) ...[
            SizedBox(width: 8.w),
            _buildActionButton(react.user.userId, isSend),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(String userId, bool isSend) {
    final isFriend = false;

    if (!isFriend) {
      return GestureDetector(
        onTap: () {
          if (!isSend) {
            setState(() {
              _sentFriendRequestUserIds.add(userId);
            });
          } else {
            setState(() {
              _sentFriendRequestUserIds.remove(userId);
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSend ? Colors.blue[50] : AppColors.primary,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: isSend
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, color: Colors.blue[700], size: 16.r),
                    SizedBox(width: 8.w),
                    Text(
                      'Đã gửi',
                      style: TextStyle(
                        color: Colors.blue[700],
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

    return OutlinedButton(
      onPressed: () {
        // TODO: Xử lý nhắc đến
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade400),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        'Nhắc đến',
        style: TextStyle(fontSize: 14.sp, color: Colors.black),
      ),
    );
  }
}
