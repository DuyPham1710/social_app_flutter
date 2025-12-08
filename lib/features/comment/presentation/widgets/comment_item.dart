import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment_entity.dart';
import 'package:social_app_fe/features/comment/domain/usecases/listen_comment_count_usecase.dart';
import 'package:social_app_fe/features/comment/domain/usecases/load_comment_usecase.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/reaction_text.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/comment_reaction_menu.dart';
import 'package:social_app_fe/features/friend/domain/usecases/get_friend_relationship_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_profile_posts_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_user_posts_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_other_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatefulWidget {
  final CommentEntity comment;
  final Function(String? parentId, String userDisplayName)? onReply;
  final List<CommentEntity>? replies;
  final bool isReply;
  final bool showReplies;
  final VoidCallback? onToggleReplies;
  final String? currentUserId;
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

  @override
  void initState() {
    super.initState();
    _showReplies = widget.showReplies;
  }

  void _onReactionChanged(String commentId, EmojiType reaction) {
    // TODO: Implement reaction logic với server
    print('Comment $commentId reacted with ${reaction.label}');
    // Có thể emit event để cập nhật server
    // _commentBloc.add(ReactToCommentEvent(commentId: commentId, reaction: reaction));
  }

  @override
  void dispose() {
    CommentReactionMenu.hide();
    super.dispose();
  }

  Future<void> _navigateToProfile(BuildContext context) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    // Nếu là user hiện tại → My Profile
    if (currentUserId == widget.comment.user.userId) {
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
      //Nếu là người khác → Other Profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                OtherProfileBloc(
                  getOtherUserProfileUseCase: di
                      .s1<GetOtherUserProfileUseCase>(),
                  getUserPostsUseCase: di.s1<GetUserPostsUseCase>(),
                  getFriendRelationshipUseCase: di
                      .s1<GetFriendRelationshipUseCase>(),
                  listenCommentCountUseCase: di.s1<ListenCommentCountUseCase>(),
                  loadCommentsUseCase: di.s1<LoadCommentsUseCase>(),
                )..add(
                  LoadOtherUserProfileEvent(
                    userId: widget.comment.user.userId!,
                  ),
                ),
            child: OtherProfilePage(userId: widget.comment.user.userId!),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('>>> comment: ${widget.comment.parentId}');
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
                    Offset(
                      position.dx,
                      position.dy - 66.h,
                    ), // canh chỉnh menu ở đầu comment
                    widget.comment,
                    onReply: widget.onReply,
                    onReactionChanged: _onReactionChanged,
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

                            ReactionText(
                              commentId: widget.comment.id,
                              onReactionChanged: _onReactionChanged,
                            ),

                            SizedBox(width: 10.w),

                            GestureDetector(
                              onTap: () {
                                // Handle reply action
                                if (widget.onReply != null) {
                                  final userName =
                                      widget.comment.user.fullName ??
                                      widget.comment.user.username ??
                                      'Unknown';

                                  if (widget.comment.parentId != null) {
                                    // Nếu đã là reply thì trả về parentId gốc
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

                      // Reaction badge (bottom right corner)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, left: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    EmojiType.love.icon,
                                    style: TextStyle(fontSize: 12.sp),
                                  ),

                                  SizedBox(width: 2.w),

                                  Text(
                                    EmojiType.haha.icon,
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  SizedBox(width: 4.w),

                                  Text(
                                    '5',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Show reply count and toggle if this comment has replies
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

                  // Show replies if expanded
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
}
