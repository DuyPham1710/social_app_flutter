import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedPostBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final double? borderRadius;
  final Color? glowColor;

  const AnimatedPostBorder({
    super.key,
    required this.child,
    this.borderWidth = 1.5,
    this.borderRadius,
    this.glowColor,
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
    final defaultGlowColor = isDarkMode ? Colors.white : Colors.black;
    final color = widget.glowColor ?? defaultGlowColor;
    final radius = widget.borderRadius ?? 12.rsr(context);

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
          Padding(
            padding: EdgeInsets.all(widget.borderWidth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: widget.child,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: _isVisible
                  ? AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _AnimatedBorderPainter(
                            animation: _controller,
                            borderWidth: widget.borderWidth,
                            borderRadius: radius,
                            glowColor: color,
                          ),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.divider.withValues(alpha: 0.3),
                          width: widget.borderWidth,
                        ),
                        borderRadius: BorderRadius.circular(
                          radius + widget.borderWidth,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final double borderWidth;
  final double borderRadius;
  final Color glowColor;

  _AnimatedBorderPainter({
    required this.animation,
    required this.borderWidth,
    required this.borderRadius,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paintRect = rect.deflate(borderWidth / 2);
    final rrect = RRect.fromRectAndRadius(
      paintRect,
      Radius.circular(borderRadius + borderWidth / 2),
    );

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = AppColors.divider.withValues(alpha: 0.3);

    canvas.drawRRect(rrect, bgPaint);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          Colors.transparent,
          glowColor,
          glowColor,
          Colors.transparent,
          Colors.transparent,
        ],
        stops: const [0.0, 0.25, 0.45, 0.55, 0.75, 1.0],
        transform: GradientRotation(animation.value * 2 * 3.141592653589793),
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _AnimatedBorderPainter oldDelegate) => true;
}
