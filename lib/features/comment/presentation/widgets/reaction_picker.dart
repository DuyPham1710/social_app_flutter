import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/shared/helpers/reaction_fly_overlay.dart';

class ReactionPicker extends StatefulWidget {
  final Function(EmojiType) onReactionSelected;
  final Widget child;
  final EmojiType? currentReaction;
  // true thì cạnh trái của khung picker sẽ thẳng hàng với cạnh trái của widget con
  final bool alignLeftToChild;

  const ReactionPicker({
    super.key,
    required this.onReactionSelected,
    required this.child,
    this.currentReaction,
    this.alignLeftToChild = false,
  });

  @override
  State<ReactionPicker> createState() => _ReactionPickerState();
}

class _ReactionPickerState extends State<ReactionPicker>
    with TickerProviderStateMixin {
  bool _isShowingReactions = false;
  OverlayEntry? _overlayEntry;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  int _hoveredIndex = -1;
  GlobalKey _childKey = GlobalKey();
  late final List<GlobalKey> _emojiKeys;

  @override
  void initState() {
    super.initState();
    _emojiKeys = List<GlobalKey>.generate(
      EmojiType.values.length,
      (_) => GlobalKey(),
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showReactionPicker() {
    if (_isShowingReactions) return;

    _isShowingReactions = true;
    _createOverlay();
    _scaleController.forward();
    _fadeController.forward();
  }

  void _createOverlay() {
    final renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);

    // --- BẮT ĐẦU TÍNH TOÁN KÍCH THƯỚC VÀ VỊ TRÍ ---
    final double iconSize = 50.w; // Kích thước Lottie icon
    final double horizontalMargin = 2.w; // Khoảng cách ngang giữa các icon
    final double containerPadding = 8.w; // Đệm bên trong khung trắng

    // Tự động tính toán tổng chiều rộng của picker
    final totalWidth =
        (iconSize + (horizontalMargin * 2)) * EmojiType.values.length +
        (containerPadding * 2);

    // Tính toán vị trí bên trái
    // - Nếu alignLeftToChild = true: canh trái khung picker trùng với trái của icon
    // - Ngược lại: canh giữa như hành vi hiện tại
    final pickerLeftPosition = widget.alignLeftToChild
        ? position.dx
        : (position.dx + renderBox.size.width / 2) - (totalWidth / 2) + 30.sp;
    // --- KẾT THÚC TÍNH TOÁN ---

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideReactionPicker,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: pickerLeftPosition,
            top: position.dy - 95.h, // Đẩy picker lên vị trí phù hợp
            child: Material(
              color: Colors.transparent,
              child: AnimatedBuilder(
                animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      // THAY ĐỔI: Khung trắng được thu nhỏ lại
                      child: Container(
                        padding: EdgeInsets.all(containerPadding),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: _hoveredIndex >= 0
                                  ? 24.h
                                  : 0, // Giảm chiều cao label
                              child: _hoveredIndex >= 0
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.textPrimary,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Text(
                                        EmojiType.values[_hoveredIndex].label,
                                        style: TextStyle(
                                          color: AppColors.background,
                                          fontSize: 10.sp, // Chữ nhỏ hơn
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            SizedBox(height: _hoveredIndex >= 0 ? 4.h : 0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: EmojiType.values.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final emoji = entry.value;
                                final isHovered = _hoveredIndex == index;

                                return GestureDetector(
                                  onTap: () => _selectReaction(emoji),
                                  child: MouseRegion(
                                    onEnter: (_) => _setHoveredIndex(index),
                                    onExit: (_) => _setHoveredIndex(-1),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: horizontalMargin,
                                      ),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        transformAlignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..scale(isHovered ? 1.2 : 1.0),
                                        child: SizedBox(
                                          key: _emojiKeys[index],
                                          width: iconSize,
                                          height: iconSize,
                                          child: Lottie.asset(
                                            emoji.lottieAsset,
                                            repeat: true,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _setHoveredIndex(int index) {
    setState(() {
      _hoveredIndex = index;
    });
  }

  void _selectReaction(EmojiType emoji) {
    // trigger fly animation: from selected emoji to the first emoji in the picker
    final int selectedIndex = EmojiType.values.indexOf(emoji);
    if (selectedIndex >= 0 && _emojiKeys.length > selectedIndex) {
      final startKey = _emojiKeys[selectedIndex];
      ReactionFlyOverlay.showFromAnchorDelta(
        context: context,
        startAnchorKey: startKey,
        emojiIcon: emoji.icon,
        delta: const Offset(-100.0, -40.0),
        arcLift: -40.0,
      );
    }

    widget.onReactionSelected(emoji);
    _hideReactionPicker();
  }

  void _hideReactionPicker() {
    if (!_isShowingReactions) return;

    _scaleController.reverse().then((_) {
      _removeOverlay();
    });
    _fadeController.reverse();
    _isShowingReactions = false;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _childKey,
      onLongPress: _showReactionPicker,
      child: widget.child,
    );
  }
}
