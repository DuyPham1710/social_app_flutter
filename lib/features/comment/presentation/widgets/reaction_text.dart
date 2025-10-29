import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/comment/presentation/widgets/reaction_picker.dart';

class ReactionText extends StatefulWidget {
  final String commentId;
  final EmojiType? initialReaction;
  final Function(String commentId, EmojiType reaction)? onReactionChanged;

  const ReactionText({
    super.key,
    required this.commentId,
    this.initialReaction,
    this.onReactionChanged,
  });

  @override
  State<ReactionText> createState() => _ReactionTextState();
}

class _ReactionTextState extends State<ReactionText> {
  EmojiType? _currentReaction;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentReaction = widget.initialReaction;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onReactionSelected(EmojiType reaction) {
    setState(() {
      if (_currentReaction == reaction) {
        _currentReaction = null;
      } else {
        _currentReaction = reaction;
      }
    });

    if (widget.onReactionChanged != null) {
      if (_currentReaction != null) {
        widget.onReactionChanged!(widget.commentId, _currentReaction!);
      }
    }
  }

  void _onTap() {
    if (_currentReaction != null) {
      setState(() {
        _currentReaction = null;
      });
    } else {
      setState(() {
        _currentReaction = EmojiType.like;
      });

      if (widget.onReactionChanged != null) {
        widget.onReactionChanged!(widget.commentId, EmojiType.like);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactionPicker(
      currentReaction: _currentReaction,
      onReactionSelected: _onReactionSelected,
      child: GestureDetector(
        key: _textKey,
        onTap: _onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _currentReaction?.label ?? 'Thích',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: _currentReaction != null
                  ? _getReactionColor(_currentReaction!)
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Color _getReactionColor(EmojiType reaction) {
    switch (reaction) {
      case EmojiType.like:
        return Colors.blue[600]!;
      case EmojiType.love:
        return Colors.red[500]!;
      case EmojiType.haha:
        return Colors.orange[600]!;
      case EmojiType.wow:
        return Colors.orange[700]!;
      case EmojiType.sad:
        return Colors.orange[600]!;
      case EmojiType.angry:
        return Colors.red[600]!;
    }
  }
}
