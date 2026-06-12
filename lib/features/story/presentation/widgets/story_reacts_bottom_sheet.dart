import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/story/domain/entities/react_story_entity.dart';
import 'package:social_app_fe/features/story/domain/entities/story_entity.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_react_list_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class StoryReactsBottomSheet extends StatefulWidget {
  final StoryEntity story;

  const StoryReactsBottomSheet({super.key, required this.story});

  static void show(BuildContext context, {required StoryEntity story}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StoryReactsBottomSheet(story: story),
    );
  }

  @override
  State<StoryReactsBottomSheet> createState() => _StoryReactsBottomSheetState();
}

class _StoryReactsBottomSheetState extends State<StoryReactsBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ReactStoryEntity> _filteredReacts;
  EmojiType? _selectedEmoji;

  @override
  void initState() {
    super.initState();

    _filteredReacts = widget.story.reacts;

    // Tính số lượng tab (Tất cả + các emoji có người react)
    final emojiCounts = <EmojiType, int>{};
    for (var react in widget.story.reacts) {
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
        _filteredReacts = widget.story.reacts;
      } else {
        // Tab emoji cụ thể
        final emojiTypes = _getUniqueEmojis();
        _selectedEmoji = emojiTypes[_tabController.index - 1];
        _filteredReacts = widget.story.reacts
            .where((react) => react.emoji == _selectedEmoji)
            .toList();
      }
    });
  }

  List<EmojiType> _getUniqueEmojis() {
    final emojiCounts = <EmojiType, int>{};
    for (var react in widget.story.reacts) {
      emojiCounts[react.emoji] = (emojiCounts[react.emoji] ?? 0) + 1;
    }

    // Sắp xếp theo số lượng (nhiều nhất trước)
    final sortedEmojis = emojiCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEmojis.map((e) => e.key).toList();
  }

  int _getEmojiCount(EmojiType emoji) {
    return widget.story.reacts.where((react) => react.emoji == emoji).length;
  }

  @override
  Widget build(BuildContext context) {
    final uniqueEmojis = _getUniqueEmojis();
    final totalCount = widget.story.reacts.length;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.rsr(context)),
          topRight: Radius.circular(20.rsr(context)),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.rs(context), vertical: 12.rsh(context)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.divider, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    CupertinoIcons.xmark,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    context.l10n.storyReactedPeople,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.rsp(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: TextStyle(fontSize: 14.rsp(context), fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.rsp(context),
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
                      style: TextStyle(fontSize: 14.rsp(context)),
                    ),
                    SizedBox(width: 8.rs(context)),
                    Text(
                      totalCount.toString(),
                      style: TextStyle(
                        fontSize: 14.rsp(context),
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
                      Text(emoji.icon, style: TextStyle(fontSize: 16.rsp(context))),
                      SizedBox(width: 8.rs(context)),
                      Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 14.rsp(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab "Tất cả"
                StoryReactListWidget(reacts: _filteredReacts),

                // Tabs cho từng emoji
                ...uniqueEmojis.map((emoji) {
                  final emojiReacts =
                      widget.story.reacts
                          .where((react) => react.emoji == emoji)
                          .toList()
                        ..sort(
                          (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
                            a.createdAt ?? DateTime.now(),
                          ),
                        );
                  return StoryReactListWidget(reacts: emojiReacts);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
