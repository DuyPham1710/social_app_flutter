import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class MessageActionSheet {
  static void show({
    required BuildContext context,
    required MessageEntity message,
    required bool fromMe,
    required GlobalKey messageKey,
    required Function(EmojiType) onReactionSelected,
    required VoidCallback onReply,
    required VoidCallback? onCopy,
    required VoidCallback? onDelete,
    required VoidCallback? onMore,
  }) {
    final RenderBox? renderBox =
        messageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _MessageActionContent(
          message: message,
          fromMe: fromMe,
          messagePosition: position,
          messageSize: size,
          animation: animation,
          onReactionSelected: (emoji) {
            onReactionSelected(emoji);
            Navigator.of(context).pop();
          },
          onReply: () {
            Navigator.of(context).pop();
            onReply();
          },
          onCopy: onCopy != null
              ? () {
                  Navigator.of(context).pop();
                  onCopy();
                }
              : null,
          onDelete: onDelete != null
              ? () {
                  Navigator.pop(context);
                  onDelete();
                }
              : null,

          onMore: onMore != null
              ? () {
                  Navigator.pop(context);
                  onMore();
                }
              : null,
        );
      },
    );
  }
}

class _MessageActionContent extends StatefulWidget {
  final MessageEntity message;
  final bool fromMe;
  final Offset messagePosition;
  final Size messageSize;
  final Animation<double> animation;
  final Function(EmojiType) onReactionSelected;
  final VoidCallback onReply;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final VoidCallback? onMore;

  const _MessageActionContent({
    required this.message,
    required this.fromMe,
    required this.messagePosition,
    required this.messageSize,
    required this.animation,
    required this.onReactionSelected,
    required this.onReply,
    this.onCopy,
    this.onDelete,
    this.onMore,
  });

  @override
  State<_MessageActionContent> createState() => _MessageActionContentState();
}

class _MessageActionContentState extends State<_MessageActionContent>
    with TickerProviderStateMixin {
  final List<AnimationController> _emojiControllers = [];
  final List<Animation<double>> _slideAnimations = [];
  final List<Animation<double>> _scaleAnimations = [];
  int _hoveredEmojiIndex = -1;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Play haptic feedback
    HapticFeedback.mediumImpact();

    // Tạo animation controller cho từng emoji với delay
    for (int i = 0; i < EmojiType.values.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
      );

      // Chỉ dùng scale animation, không có slide
      final slideAnimation = Tween<double>(
        begin: 0.0,
        end: 0.0,
      ).animate(controller);

      final scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));

      _emojiControllers.add(controller);
      _slideAnimations.add(slideAnimation);
      _scaleAnimations.add(scaleAnimation);

      // Start animation và play sound cho mỗi icon với delay tăng dần
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) {
          // Play sound khi icon xuất hiện
          _playPopSound();
          // Start animation
          controller.forward();
        }
      });
    }
  }

  Future<void> _playPopSound() async {
    try {
      // Set volume and playback rate for a quick pop sound
      await _audioPlayer.setVolume(0.5);
      await _audioPlayer.setPlaybackRate(1.2);

      // Play the pop sound effect
      await _audioPlayer.play(AssetSource('sounds/sound_react.mp3'));
    } catch (e) {
      // Silent fail - haptic feedback already played
      // If sound file doesn't exist, the app will continue without sound
    }
  }

  @override
  void dispose() {
    for (var controller in _emojiControllers) {
      controller.dispose();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Tính toán vị trí emoji reaction bar
    final emojiBarHeight = 60.h;
    final emojiBarWidth = 290.w;
    double emojiBarTop = widget.messagePosition.dy - emojiBarHeight - 10.h;

    // Nếu không đủ chỗ phía trên, hiện phía dưới
    // if (emojiBarTop < 100.h) {
    //   emojiBarTop =
    //       widget.messagePosition.dy + widget.messageSize.height + 10.h;
    // }

    // Luôn căn giữa emoji bar theo màn hình (không theo message)
    double emojiBarLeft = (screenWidth - emojiBarWidth) / 2;

    return Stack(
      children: [
        // Emoji Reactions Bar (trên message)
        Positioned(
          top: emojiBarTop,
          left: emojiBarLeft,
          child: FadeTransition(
            opacity: widget.animation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(EmojiType.values.length, (index) {
                    final emoji = EmojiType.values[index];
                    final isHovered = _hoveredEmojiIndex == index;

                    return AnimatedBuilder(
                      animation: _emojiControllers[index],
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_slideAnimations[index].value, 0),

                          child: Transform.scale(
                            scale: _scaleAnimations[index].value,
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                widget.onReactionSelected(emoji);
                              },
                              child: MouseRegion(
                                onEnter: (_) => setState(() {
                                  _hoveredEmojiIndex = index;
                                  HapticFeedback.selectionClick();
                                }),
                                onExit: (_) =>
                                    setState(() => _hoveredEmojiIndex = -1),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  transform: Matrix4.identity()
                                    ..scale(isHovered ? 1.3 : 1.0),
                                  child: Container(
                                    width: 38.w,
                                    height: 38.w,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                    ),
                                    child: Center(
                                      child: Text(
                                        emoji.icon,
                                        style: TextStyle(fontSize: 24.sp),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
        ),

        // Bottom Action Buttons
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(
                  CurvedAnimation(
                    parent: widget.animation,
                    curve: Curves.easeOut,
                  ),
                ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Reply Action
                      _buildActionItem(
                        icon: CupertinoIcons.arrowshape_turn_up_left_fill,
                        label: context.l10n.commentReply,
                        onTap: widget.onReply,
                      ),

                      // Copy Action (if message has text)
                      if (widget.message.text != null &&
                          widget.message.text!.isNotEmpty &&
                          widget.onCopy != null)
                        _buildActionItem(
                          icon: CupertinoIcons.doc_on_doc_fill,
                          label: context.l10n.commonCopy,
                          onTap: widget.onCopy!,
                        ),

                      // Delete Action (if from me)
                      if (widget.fromMe && widget.onDelete != null)
                        _buildActionItem(
                          icon: CupertinoIcons.trash_fill,
                          label: context.l10n.commonDelete,
                          onTap: widget.onDelete!,
                          isDestructive: true,
                        ),

                      // More Action
                      _buildActionItem(
                        icon: CupertinoIcons.line_horizontal_3,
                        label: context.l10n.chatMore,
                        onTap: widget.onMore!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isDestructive ? Colors.red : AppColors.textPrimary,
                size: 22.sp,
              ),

              SizedBox(height: 6.h),

              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDestructive ? Colors.red : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
