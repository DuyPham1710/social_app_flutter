import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/story/domain/entities/story_entity.dart';
import 'package:social_app_fe/features/story/presentation/bloc/home_stories_bloc.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/chat/domain/usecases/create_conversation_usecase.dart';
import 'package:social_app_fe/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:social_app_fe/core/resources/data_state.dart';

class StoryFooterWidget extends StatefulWidget {
  final TextEditingController textController;
  final StoryEntity story;
  final String? currentUserId;
  final bool isOwnStory;
  final ValueChanged<bool>? onFocusChanged;

  const StoryFooterWidget({
    super.key,
    required this.textController,
    required this.story,
    this.currentUserId,
    this.isOwnStory = false,
    this.onFocusChanged,
  });

  @override
  State<StoryFooterWidget> createState() => _StoryFooterWidgetState();
}

class _StoryFooterWidgetState extends State<StoryFooterWidget> {
  EmojiType? _selectedReact;
  final List<OverlayEntry> _activeEntries = [];
  final FocusNode _focusNode = FocusNode();
  bool _showSendButton = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _selectedReact = widget.story.isReact;
    _focusNode.addListener(_onFocusChange);
    widget.textController.addListener(_onTextChanged);
    _showSendButton = widget.textController.text.trim().isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant StoryFooterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.story.id != widget.story.id ||
        oldWidget.story.isReact != widget.story.isReact) {
      _selectedReact = widget.story.isReact;
    }
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    final entries = List<OverlayEntry>.from(_activeEntries);
    _activeEntries.clear();
    for (final entry in entries) {
      try {
        entry.remove();
      } catch (_) {}
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.onFocusChanged != null) {
      widget.onFocusChanged!(_focusNode.hasFocus);
    }
  }

  void _onTextChanged() {
    final hasText = widget.textController.text.trim().isNotEmpty;
    if (hasText != _showSendButton) {
      setState(() {
        _showSendButton = hasText;
      });
    }
  }

  Future<void> _sendStoryReply(BuildContext context) async {
    final text = widget.textController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      final currentUserId = widget.currentUserId;
      if (currentUserId == null) {
        throw Exception('User not logged in');
      }

      // 1. Create or get conversation with story owner
      final createConversationUseCase = s1<CreateConversationUseCase>();
      final result = await createConversationUseCase(
        params: CreateConversationParams(
          userId: currentUserId,
          participantIds: [widget.story.user.userId],
        ),
      );

      if (result is DataStateSuccess && result.data != null) {
        final conversation = result.data!;

        // 2. Send message replying to the story
        final sendMessageUseCase = s1<SendMessageUseCase>();
        sendMessageUseCase(
          userId: currentUserId,
          conversationId: conversation.id,
          text: text,
          storyId: widget.story.id,
        );

        // Clear input and unfocus
        widget.textController.clear();
        _focusNode.unfocus();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8.w),
                  const Text('Đã gửi phản hồi tin'),
                ],
              ),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        }
      } else {
        throw Exception(
          result.error?.message ?? 'Không thể tạo cuộc hội thoại',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _spawnFloatingEmojiBurst(
    BuildContext context,
    Offset startPosition,
    String emoji,
  ) {
    final overlayState = Overlay.maybeOf(context);
    if (overlayState == null) return;

    final random = math.Random();

    // Tạo 8 emoji bay lên tạo thành dòng phun nước (fountain effect)
    for (int i = 0; i < 8; i++) {
      final delayMs = i * 80 + random.nextInt(40);
      late OverlayEntry entry;

      entry = OverlayEntry(
        builder: (context) {
          return _FloatingEmojiWidget(
            startPosition: startPosition,
            emoji: emoji,
            delayMs: delayMs,
            onComplete: () {
              if (mounted && _activeEntries.contains(entry)) {
                try {
                  entry.remove();
                } catch (_) {}
                _activeEntries.remove(entry);
              }
            },
          );
        },
      );

      _activeEntries.add(entry);
      overlayState.insert(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nếu là story của chính mình, không hiển thị footer
    if (widget.isOwnStory) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 16.h,
      child: Listener(
        // Sử dụng Listener để bắt pointer events và ngăn propagation
        onPointerDown: (_) {
          // Ngăn event propagation lên parent
        },
        child: SizedBox(
          height: 44.h, // Chiều cao cố định cho cả thanh cuộn
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
            ), // Padding cho 2 đầu
            children: [
              SizedBox(
                width: 230.w,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.textController,
                          focusNode: _focusNode,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) => _sendStoryReply(context),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Gửi tin nhắn...',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ), // Màu xám nhạt
                          ),
                        ),
                      ),
                      if (_showSendButton)
                        GestureDetector(
                          onTap: _isSending
                              ? null
                              : () => _sendStoryReply(context),
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: _isSending
                                ? SizedBox(
                                    width: 16.w,
                                    height: 16.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.send_rounded,
                                    color: AppColors.primary,
                                    size: 20.sp,
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              ...EmojiType.values.map((emoji) {
                final isReacted = _selectedReact == emoji;
                return Padding(
                  // Thêm padding bên trái cho mỗi icon để tạo khoảng cách
                  padding: EdgeInsets.only(left: 8.w),
                  child: _IconReaction(
                    emoji: emoji,
                    storyId: widget.story.id,
                    isReacted: isReacted,
                    onTap: (details) {
                      setState(() {
                        if (isReacted) {
                          _selectedReact = null;
                        } else {
                          _selectedReact = emoji;
                        }
                      });

                      if (_selectedReact == emoji) {
                        _spawnFloatingEmojiBurst(
                          context,
                          details.globalPosition,
                          emoji.icon,
                        );
                      }

                      // Gọi bloc để react story (nếu đã react sẽ xóa, nếu chưa sẽ tạo)
                      context.read<HomeStoriesBloc>().add(
                        ReactStoryEvent(
                          storyId: widget.story.id,
                          emojiId: emoji.id,
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget phụ trợ cho icon, chỉ dùng trong file này
class _IconReaction extends StatelessWidget {
  final EmojiType emoji;
  final String storyId;
  final bool isReacted;
  final Function(TapDownDetails details) onTap;

  const _IconReaction({
    required this.emoji,
    required this.storyId,
    this.isReacted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ngăn event propagation
      behavior: HitTestBehavior.opaque,
      onTapDown: onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: 65.w,
            height: 65.w,
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Lottie.asset(
              emoji.lottieAsset,
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
          if (isReacted)
            Positioned(
              top: 2.w,
              right: 2.w,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5.w),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Widget hiệu ứng emoji bay lên
class _FloatingEmojiWidget extends StatefulWidget {
  final Offset startPosition;
  final String emoji;
  final int delayMs;
  final VoidCallback onComplete;

  const _FloatingEmojiWidget({
    required this.startPosition,
    required this.emoji,
    required this.delayMs,
    required this.onComplete,
  });

  @override
  State<_FloatingEmojiWidget> createState() => _FloatingEmojiWidgetState();
}

class _FloatingEmojiWidgetState extends State<_FloatingEmojiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _swerveWidth;
  late double _swerveFrequency;
  late double _targetHeight;
  late double _scale;
  late double _angle;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _swerveWidth =
        25.0 + random.nextDouble() * 35.0; // Biên độ uốn lượn 25-60px
    _swerveFrequency = 1.0 + random.nextDouble() * 1.5; // Số nhịp uốn lượn
    _targetHeight =
        300.0 + random.nextDouble() * 200.0; // Độ cao bay lên 300-500px
    _scale = 0.9 + random.nextDouble() * 0.4; // Kích thước ngẫu nhiên
    _angle = (random.nextDouble() - 0.5) * 0.4; // Góc nghiêng ngẫu nhiên

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1300 + random.nextInt(400),
      ), // Thời gian bay 1.3s - 1.7s
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    if (widget.delayMs > 0) {
      await Future.delayed(Duration(milliseconds: widget.delayMs));
    }
    if (mounted) {
      setState(() {
        _isVisible = true;
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;

        // Trục Y di chuyển ngược lên trên
        final currentY = widget.startPosition.dy - (progress * _targetHeight);

        // Trục X chuyển động lượn sóng hình Sin
        final currentX =
            widget.startPosition.dx +
            math.sin(progress * math.pi * 2 * _swerveFrequency) * _swerveWidth;

        // Độ mờ: xuất hiện nhanh, mờ dần về cuối hành trình
        double opacity = 1.0;
        if (progress < 0.15) {
          opacity = progress / 0.15;
        } else if (progress > 0.6) {
          opacity = (1.0 - progress) / 0.4;
        }
        opacity = opacity.clamp(0.0, 1.0);

        // Kích cỡ: phóng to nhẹ khi vừa bay ra, thu nhỏ dần khi tan biến
        double currentScale = _scale;
        if (progress < 0.2) {
          currentScale = _scale * (progress / 0.2);
        } else if (progress > 0.7) {
          currentScale = _scale * ((1.0 - progress) / 0.3);
        }

        return Positioned(
          left: currentX - 25, // Căn giữa hộp kích thước 50x50
          top: currentY - 25,
          child: IgnorePointer(
            // Không cản trở các tương tác click khác dưới màn hình
            child: Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: _angle + (progress * 0.15), // Xoay nhẹ khi đang bay
                child: Transform.scale(
                  scale: currentScale,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 34),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
