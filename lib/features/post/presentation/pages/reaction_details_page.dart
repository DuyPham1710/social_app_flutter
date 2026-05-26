import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/presentation/widgets/react_widgets/react_list_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ReactionDetailsPage extends StatefulWidget {
  final List<ReactPostEntity> reacts;
  final String postId;
  final Function(
    String userId,
    String userAvatar,
    String? parentId,
    String userDisplayName,
  )?
  onMention;
  const ReactionDetailsPage({
    super.key,
    required this.reacts,
    required this.postId,
    this.onMention,
  });

  @override
  State<ReactionDetailsPage> createState() => _ReactionDetailsPageState();
}

class _ReactionDetailsPageState extends State<ReactionDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ReactPostEntity> _filteredReacts;
  EmojiType? _selectedEmoji;

  @override
  void initState() {
    super.initState();

    _filteredReacts = widget.reacts;

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

    context.read<FriendBloc>().add(const LoadSentFriendRequests());
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
        _filteredReacts = widget.reacts;
      } else {
        // Tab emoji cụ thể
        final emojiTypes = _getUniqueEmojis();
        _selectedEmoji = emojiTypes[_tabController.index - 1];
        _filteredReacts = widget.reacts
            .where((react) => react.emoji == _selectedEmoji)
            .toList();
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
          context.l10n.postPeopleReactedTitle,
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
                  Text(
                    context.l10n.commonAll,
                    style: TextStyle(fontSize: 14.sp),
                  ),

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
          ReactListWidget(reacts: _filteredReacts, onMention: widget.onMention),

          // Tabs cho từng emoji
          ...uniqueEmojis.map((emoji) {
            final emojiReacts =
                widget.reacts.where((react) => react.emoji == emoji).toList()
                  ..sort(
                    (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
                      a.createdAt ?? DateTime.now(),
                    ),
                  );
            return ReactListWidget(
              reacts: emojiReacts,
              onMention: widget.onMention,
            );
          }),
        ],
      ),
    );
  }
}
