import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/comment/presentation/pages/modal_comment.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/reaction_picker.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_event.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';

class PostAction extends StatefulWidget {
  final String postId;
  final int reactCount;
  final EmojiType? isReact;
  final int commentCount;
  final List<ReactPostEntity>? reacts;
  final void Function(EmojiType? newReaction)? onReactionChanged;

  const PostAction({
    super.key,
    required this.postId,
    this.reactCount = 0,
    this.commentCount = 0,
    this.isReact,
    this.reacts,
    this.onReactionChanged,
  });

  @override
  State<PostAction> createState() => _PostActionState();
}

class _PostActionState extends State<PostAction> {
  String get postId => widget.postId;
  late int _reactCount;
  int get commentCount => widget.commentCount;
  EmojiType? _currentReaction;
  final GlobalKey _iconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentReaction = widget.isReact;
    _reactCount = widget.reactCount;
  }

  @override
  void didUpdateWidget(PostAction oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isReact != widget.isReact) {
      setState(() {
        _reactCount = widget.reactCount;
        _currentReaction = widget.isReact;
      });
    }
  }

  void _handleReactionSelected(EmojiType reaction) {
    final wasReacted = _currentReaction != null;
    // Gọi BLoC event để react post
    context.read<HomeBloc>().add(
      ReactPostEvent(postId: postId, emojiId: reaction.id),
    );

    setState(() {
      if (_currentReaction == reaction) {
        _currentReaction = null;
        // giảm đi 1 vì người dùng đã hủy reaction
        if (_reactCount > 0) _reactCount--;
      } else {
        // Nếu chưa react hoặc đổi sang emoji khác -> +1 hoặc giữ nguyên
        if (!wasReacted) _reactCount++;
        _currentReaction = reaction;
      }
    });

    // Notify parent để cập nhật PostReactInfo
    widget.onReactionChanged?.call(_currentReaction);
  }

  void _handleIconTap() {
    if (_currentReaction != null) {
      // Đã react -> Hủy react bằng cách gọi lại với emoji hiện tại
      context.read<HomeBloc>().add(
        ReactPostEvent(postId: postId, emojiId: _currentReaction!.id),
      );

      setState(() {
        _currentReaction = null;
        if (_reactCount > 0) _reactCount--;
      });
    } else {
      // Chưa react -> React với emoji like mặc định
      context.read<HomeBloc>().add(
        ReactPostEvent(postId: postId, emojiId: EmojiType.like.id),
      );

      setState(() {
        _currentReaction = EmojiType.like;
        _reactCount++;
      });
    }

    // Notify parent để cập nhật PostReactInfo
    widget.onReactionChanged?.call(_currentReaction);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasReacted = _currentReaction != null;
    final String emojiIcon = _currentReaction?.icon ?? '👍';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Wrap với GestureDetector để xử lý onTap riêng
              GestureDetector(
                onTap: _handleIconTap,
                child: ReactionPicker(
                  alignLeftToChild: true,
                  currentReaction: _currentReaction,
                  onReactionSelected: _handleReactionSelected,
                  child: hasReacted
                      ? Text(
                          emojiIcon,
                          key: _iconKey,
                          style: TextStyle(fontSize: 20.sp),
                        )
                      : Icon(
                          CupertinoIcons.hand_thumbsup,
                          key: _iconKey,
                          color: AppColors.unselectedIcon,
                          size: 24.sp,
                        ),
                ),
              ),

              SizedBox(width: 8.w),

              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return ModalComment(
                        postId: postId,
                        reacts: widget.reacts,
                      );
                    },
                  );
                },
                child: Text(
                  "$_reactCount",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return ModalComment(
                        postId: postId,
                        reacts: widget.reacts,
                        isPressComment: true,
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.chat_bubble,
                      color: AppColors.unselectedIcon,
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "$commentCount",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return ModalComment(
                    postId: postId,
                    reacts: widget.reacts,
                    isPressComment: true,
                  );
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                commentCount > 0
                    ? "Xem tất cả $commentCount bình luận"
                    : "Chưa có bình luận nào",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
