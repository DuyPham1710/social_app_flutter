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

class _ReactionTextState extends State<ReactionText>
    with TickerProviderStateMixin {
  EmojiType? _currentReaction;
  late AnimationController _flyAnimationController;
  late Animation<double> _animationX; // Animation cho trục X (ngang)
  late Animation<double> _animationY; // Animation cho trục Y (dọc)
  late Animation<double> _scaleAnimation; // Animation cho phóng to/nhỏ
  late Animation<double> _opacityAnimation; // Animation cho mờ dần

  OverlayEntry? _flyingEmojiEntry;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentReaction = widget.initialReaction;

    // 1. Controller chính, điều khiển toàn bộ animation
    _flyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 450), // Tăng thời gian để mượt hơn
      vsync: this,
    );

    // 2. Animation di chuyển ngang (Trục X)
    // Bay từ vị trí ban đầu (0.0) sang trái (-75.0 pixels)
    // Dùng easeOutCubic để lúc đầu bay nhanh, sau đó chậm dần
    _animationX = Tween<double>(begin: 0.0, end: -75.0).animate(
      CurvedAnimation(
        parent: _flyAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // 3. Animation di chuyển dọc (Trục Y) - TẠO VÒNG CUNG
    // Dùng TweenSequence để bay lên rồi rơi xuống
    _animationY = TweenSequence<double>([
      // Giai đoạn 1: Bay vọt lên cao (-80.0 pixels)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -80.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50, // Chiếm 50% thời gian
      ),
      // Giai đoạn 2: Rơi nhẹ xuống một chút khi bay ngang
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -80.0,
          end: -40.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50, // Chiếm 50% thời gian còn lại
      ),
    ]).animate(_flyAnimationController);

    // 4. Animation phóng to rồi thu nhỏ (Hiệu ứng "nảy")
    _scaleAnimation = TweenSequence<double>([
      // Giai đoạn 1: Phóng to rất nhanh để "nảy" lên
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.5), weight: 25),
      // Giai đoạn 2: Thu nhỏ dần về 0
      TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 0.0), weight: 75),
    ]).animate(_flyAnimationController);

    // 5. Animation mờ dần
    // Giữ nguyên độ sáng ở nửa đầu, sau đó mờ dần về 0
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 40),
    ]).animate(_flyAnimationController);
  }

  @override
  void dispose() {
    _flyAnimationController.dispose();
    _removeFlyingEmoji();
    super.dispose();
  }

  // Các hàm _onTap, _onReactionSelected giữ nguyên...
  void _onReactionSelected(EmojiType reaction) {
    _showFlyingEmoji(reaction);

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

  // Hàm _showFlyingEmoji được cập nhật để dùng các animation mới
  void _showFlyingEmoji(EmojiType emoji) {
    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _removeFlyingEmoji();

    _flyingEmojiEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + size.width / 2 - 15.w,
        top: position.dy - 15.h,
        child: Material(
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: _flyAnimationController,
            builder: (context, child) {
              // Áp dụng các animation đã tạo
              return Transform.translate(
                offset: Offset(_animationX.value, _animationY.value),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: child,
                  ),
                ),
              );
            },
            // Child này là icon emoji, được truyền vào builder để tối ưu hiệu năng
            child: Text(emoji.icon, style: TextStyle(fontSize: 30.sp)),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_flyingEmojiEntry!);

    _flyAnimationController.forward(from: 0.0).then((_) {
      _removeFlyingEmoji();
    });
  }

  void _removeFlyingEmoji() {
    _flyingEmojiEntry?.remove();
    _flyingEmojiEntry = null;
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
