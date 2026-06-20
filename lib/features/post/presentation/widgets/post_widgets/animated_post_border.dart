import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedPostBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;

  const AnimatedPostBorder({
    super.key,
    required this.child,
    this.borderWidth = 1.5,
  });

  @override
  State<AnimatedPostBorder> createState() => _AnimatedPostBorderState();
}

class _AnimatedPostBorderState extends State<AnimatedPostBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final glowColor = isDarkMode ? Colors.white : Colors.black;

    return VisibilityDetector(
      key: widget.key ?? ValueKey(widget.hashCode),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        final visible = info.visibleFraction > 0.5;
        if (visible != _isVisible) {
          setState(() {
            _isVisible = visible;
          });
          if (visible) {
            _controller.repeat();
          } else {
            _controller.stop();
          }
        }
      },
      child: Stack(
        children: [
          // Nền phía sau (để che những chỗ không có gradient)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.divider.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(
                  12.rsr(context) + widget.borderWidth,
                ),
              ),
            ),
          ),

          // Gradient xoay vòng
          if (_isVisible)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  12.rsr(context) + widget.borderWidth,
                ),
                child: Transform.scale(
                  scale: 2.0, // Phóng to để khi xoay không bị cắt góc
                  child: RotationTransition(
                    turns: _controller,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: SweepGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            glowColor,
                            glowColor,
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.25, 0.45, 0.55, 0.75, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Nội dung chính
          Padding(
            padding: EdgeInsets.all(widget.borderWidth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
