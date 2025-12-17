import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_details_event.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/reaction_list_modal.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/reaction_text.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/comment_reaction_menu.dart';
import 'package:social_app_fe/features/comment/domain/entities/react_comment_entity.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:collection/collection.dart';

class CommentItem extends StatefulWidget {
  final CommentEntity comment;
  final Function(String? parentId, String userDisplayName)? onReply;
  final List<CommentEntity>? replies;
  final bool isReply;
  final bool showReplies;
  final VoidCallback? onToggleReplies;
  final String? currentUserId;
  final String? currentUserAvatar;
  final Function(String commentId, String newContent)? onUpdateComment;
  final Function(String commentId, String postId)? onDeleteComment;
  final Function(String commentId, String currentContent)? onViewHistory;

  const CommentItem({
    super.key,
    required this.comment,
    this.onReply,
    this.replies,
    this.isReply = false,
    this.showReplies = false,
    this.onToggleReplies,
    this.currentUserId,
    this.currentUserAvatar,
    this.onUpdateComment,
    this.onDeleteComment,
    this.onViewHistory,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final GlobalKey _commentKey = GlobalKey();
  bool _showReplies = false;

  // Getter tiện ích để lấy danh sách reacts trực tiếp từ entity
  List<ReactCommentEntity> get _reacts => widget.comment.reacts ?? [];

  @override
  void initState() {
    super.initState();
    _showReplies = widget.showReplies;
  }

  @override
  void didUpdateWidget(covariant CommentItem oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _onReactionChanged(
    BuildContext context,
    String commentId,
    EmojiType reaction,
  ) async {
    if (widget.currentUserId == null) return;

    final userData = await TokenStorage.getUserData();
    final avatarUrl = userData?['avatarUrl'];
    // Gửi sự kiện vào Bloc - Bloc sẽ lo việc update list và gọi API
    context.read<CommentDetailsBloc>().add(
      ReactCommentEvent(
        commentId: commentId,
        emoji: reaction,
        currentUserId: widget.currentUserId!,
        currentUserAvatar: avatarUrl,
      ),
    );
  }

  // Đã bỏ comment và sửa logic để lấy từ widget.comment.reacts
  EmojiType? _getCurrentUserReaction() {
    if (widget.currentUserId == null || _reacts.isEmpty) {
      return null;
    }

    // Tìm react của user hiện tại trong list
    final react = _reacts.firstWhereOrNull(
      (r) => r.user.userId == widget.currentUserId,
    );
    return react?.emoji;
  }

  @override
  void dispose() {
    CommentReactionMenu.hide();
    super.dispose();
  }

  Future<void> _navigateToProfile(BuildContext context) async {
    _navigateToUserProfile(context, widget.comment.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '[CommentItem] build commentId=${widget.comment.id} reactsCount=${_reacts.length}',
    );

    return Container(
      padding: widget.isReply
          ? EdgeInsets.fromLTRB(0.w, 8.h, 4.w, 8.h)
          : EdgeInsets.fromLTRB(12.w, 8.h, 4.w, 16.h),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: CircleAvatar(
              radius: widget.isReply ? 14.r : 18.r,
              backgroundImage: NetworkImage(
                widget.comment.user.avatarUrl ??
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
              ),
            ),
          ),

          SizedBox(width: 10.w),

          // Comment content
          Expanded(
            child: GestureDetector(
              key: _commentKey,
              onLongPressStart: (details) {
                FocusScope.of(context).unfocus();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final renderBox =
                      _commentKey.currentContext?.findRenderObject()
                          as RenderBox?;
                  if (renderBox == null) return;

                  final position = renderBox.localToGlobal(Offset.zero);

                  CommentReactionMenu.show(
                    context,
                    Offset(position.dx, position.dy - 66.h),
                    widget.comment,
                    onReply: widget.onReply,
                    onReactionChanged: (commentId, emoji) =>
                        _onReactionChanged(context, commentId, emoji),
                    currentUserId: widget.currentUserId,
                    onUpdateComment: widget.onUpdateComment,
                    onDeleteComment: widget.onDeleteComment,
                    onViewHistory: widget.onViewHistory,
                  );
                });
              },

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comment container
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCommentItem,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _navigateToProfile(context),
                          child: Text(
                            widget.comment.user.fullName ?? 'Unknown',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          widget.comment.content,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bottom actions: date, like, reply
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, left: 6.w),
                        child: Row(
                          children: [
                            Text(
                              widget.comment.updatedAt != null
                                  ? timeago.format(widget.comment.updatedAt!)
                                  : "Unknown date",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 10.w),

                            // ReactionText giờ dùng logic từ entity
                            ReactionText(
                              commentId: widget.comment.id,
                              initialReaction: _getCurrentUserReaction(),
                              // Truyền context để gọi hàm _onReactionChanged
                              onReactionChanged: (id, emoji) =>
                                  _onReactionChanged(context, id, emoji),
                            ),

                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () {
                                if (widget.onReply != null) {
                                  final userName =
                                      widget.comment.user.fullName ??
                                      widget.comment.user.username ??
                                      'Unknown';
                                  if (widget.comment.parentId != null) {
                                    widget.onReply!(
                                      widget.comment.parentId!.id,
                                      userName,
                                    );
                                  } else {
                                    widget.onReply!(
                                      widget.comment.id,
                                      userName,
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Trả lời',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Reaction badge
                      _buildReactionBadge(),
                    ],
                  ),

                  // Show reply count and toggle
                  if (widget.replies != null && widget.replies!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, left: 6.w),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showReplies = !_showReplies;
                          });
                          widget.onToggleReplies?.call();
                        },
                        child: Row(
                          children: [
                            Icon(
                              _showReplies
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 16.sp,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Xem ${widget.replies!.length} phản hồi',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Show replies
                  if (_showReplies &&
                      widget.replies != null &&
                      widget.replies!.isNotEmpty)
                    Column(
                      children: widget.replies!.map((reply) {
                        return Container(
                          margin: EdgeInsets.only(left: 10.w, top: 8.h),
                          child: CommentItem(
                            comment: reply,
                            onReply: widget.onReply,
                            isReply: true,
                            currentUserId: widget.currentUserId,
                            onUpdateComment: widget.onUpdateComment,
                            onDeleteComment: widget.onDeleteComment,
                            onViewHistory: widget.onViewHistory,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionBadge() {
    if (_reacts.isEmpty) {
      return const SizedBox.shrink();
    }

    final Map<EmojiType, int> emojiCount = {};
    for (final react in _reacts) {
      emojiCount[react.emoji] = (emojiCount[react.emoji] ?? 0) + 1;
    }

    final sortedEmojis = emojiCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topEmojis = sortedEmojis.take(2).toList();
    final totalCount = _reacts.length;

    return GestureDetector(
      onTap: () => _showReactListModal(context),
      child: Padding(
        padding: EdgeInsets.only(top: 4.h, left: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 26.w,
                    height: 18.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (int i = 0; i < topEmojis.length; i++)
                          Positioned(
                            left: (i * 14),
                            child: Text(
                              topEmojis[i].key.icon,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '$totalCount',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showReactListModal(BuildContext context) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];
    ReactionListModal.show(context, _reacts, currentUserId, (userId) {
      _navigateToUserProfile(context, userId);
    });
  }

  Future<void> _navigateToUserProfile(
    BuildContext context,
    String userId,
  ) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    if (currentUserId == userId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                di.s1<ProfileBloc>()..add(const LoadUserProfileEvent()),
            child: const ProfilePage(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                di.s1<OtherProfileBloc>()
                  ..add(LoadOtherUserProfileEvent(userId: userId)),
            child: OtherProfilePage(userId: userId),
          ),
        ),
      );
    }
  }
}
