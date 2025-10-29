import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/comment/presentation/pages/modal_comment.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/reaction_picker.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_event.dart';

class PostAction extends StatefulWidget {
  final String postId;
  final int reactCount;
  final EmojiType? isReact;
  final int commentCount;
  // final void Function(EmojiType? newReaction)? onReactionChanged;

  const PostAction({
    super.key,
    required this.postId,
    this.reactCount = 0,
    this.commentCount = 0,
    this.isReact,
    //  this.onReactionChanged,
  });

  @override
  State<PostAction> createState() => _PostActionState();
}

class _PostActionState extends State<PostAction> {
  String get postId => widget.postId;
  int get reactCount => widget.reactCount;
  int get commentCount => widget.commentCount;
  EmojiType? _currentReaction;
  final GlobalKey _iconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentReaction = widget.isReact;
  }

  void _handleReactionSelected(EmojiType reaction) {
    // Gọi BLoC event để react post
    context.read<HomeBloc>().add(
      ReactPostEvent(postId: postId, emojiId: reaction.id),
    );

    setState(() {
      if (_currentReaction == reaction) {
        _currentReaction = null;
      } else {
        _currentReaction = reaction;
      }
    });
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
              ReactionPicker(
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
                        color: Colors.grey,
                        size: 24.sp,
                      ),
              ),

              SizedBox(width: 8.w),

              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return ModalComment(postId: postId);
                    },
                  );
                },
                child: Text("$reactCount", style: TextStyle(fontSize: 12.sp)),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return ModalComment(postId: postId, isPressComment: true);
                    },
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.chat_bubble,
                      color: Colors.black87,
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text("$commentCount", style: TextStyle(fontSize: 12.sp)),
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
                  return ModalComment(postId: postId, isPressComment: true);
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                commentCount > 0
                    ? "View all $commentCount comment${commentCount > 1 ? 's' : ''}"
                    : "No comments yet",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
