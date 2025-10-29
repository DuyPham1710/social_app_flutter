import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReactionFlyOverlay {
  ReactionFlyOverlay._();

  static void showFromAnchorDelta({
    required BuildContext context,
    required GlobalKey startAnchorKey,
    required String emojiIcon,
    Offset delta = const Offset(-80.0, -40.0),
    double arcLift = -40.0,
    Duration duration = const Duration(milliseconds: 350),
    double baseIconSizeSp = 30.0,
  }) {
    final startBox =
        startAnchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (startBox == null) return;

    final startPos = startBox.localToGlobal(Offset.zero);
    final startSize = startBox.size;

    // Start and end centers
    final Offset p0 =
        startPos + Offset(startSize.width / 2, startSize.height / 2);
    final Offset p2 = p0 + delta;

    // Control point to create a small arc upwards
    final Offset mid = Offset((p0.dx + p2.dx) / 2, (p0.dy + p2.dy) / 2);
    final Offset p1 = Offset(mid.dx, mid.dy + arcLift);

    final controller = AnimationController(
      duration: duration,
      vsync: Overlay.of(context),
    );

    final animationT = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    final scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.3), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.6), weight: 50),
    ]).animate(animationT);

    final opacityAnim = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 70),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(animationT);

    Offset bezier(double t) {
      final mt = 1 - t;
      return (p0 * (mt * mt)) + (p1 * (2 * mt * t)) + (p2 * (t * t));
    }

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) {
        final t = animationT.value;
        final pos = bezier(t);
        return Positioned(
          left: pos.dx - (baseIconSizeSp.sp / 2),
          top: pos.dy - (baseIconSizeSp.sp / 2),
          child: Material(
            color: Colors.transparent,
            child: AnimatedBuilder(
              animation: animationT,
              builder: (context, child) {
                return Transform.scale(
                  scale: scaleAnim.value,
                  child: Opacity(opacity: opacityAnim.value, child: child),
                );
              },
              child: Text(
                emojiIcon,
                style: TextStyle(fontSize: baseIconSizeSp.sp),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(entry);
    controller.addListener(() {
      entry?.markNeedsBuild();
    });
    controller.forward(from: 0.0).whenComplete(() {
      entry?.remove();
      controller.dispose();
    });
  }
  // static void show({
  //   required BuildContext context,
  //   required GlobalKey anchorKey,
  //   required String emojiIcon,
  //   Duration duration = const Duration(milliseconds: 450),
  //   Offset startOffset = Offset.zero,
  //   double horizontalTravel = -75.0,
  //   double peakHeight = -80.0,
  //   double endHeight = -40.0,
  //   double baseIconSizeSp = 30.0,
  // }) {
  //   final renderBox =
  //       anchorKey.currentContext?.findRenderObject() as RenderBox?;
  //   if (renderBox == null) return;

  //   final position = renderBox.localToGlobal(Offset.zero);
  //   final size = renderBox.size;

  //   final AnimationController controller = AnimationController(
  //     duration: duration,
  //     vsync: Overlay.of(context),
  //   );

  //   final Animation<double> animX = Tween<double>(
  //     begin: startOffset.dx,
  //     end: startOffset.dx + horizontalTravel,
  //   ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

  //   final Animation<double> animY = TweenSequence<double>([
  //     TweenSequenceItem(
  //       tween: Tween<double>(
  //         begin: startOffset.dy,
  //         end: peakHeight,
  //       ).chain(CurveTween(curve: Curves.easeOut)),
  //       weight: 50,
  //     ),
  //     TweenSequenceItem(
  //       tween: Tween<double>(
  //         begin: peakHeight,
  //         end: endHeight,
  //       ).chain(CurveTween(curve: Curves.easeIn)),
  //       weight: 50,
  //     ),
  //   ]).animate(controller);

  //   final Animation<double> scaleAnim = TweenSequence<double>([
  //     TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.5), weight: 25),
  //     TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 0.0), weight: 75),
  //   ]).animate(controller);

  //   final Animation<double> opacityAnim = TweenSequence<double>([
  //     TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
  //     TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 40),
  //   ]).animate(controller);

  //   OverlayEntry? entry;
  //   entry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       left: position.dx + size.width / 2 - 15.w,
  //       top: position.dy - 15.h,
  //       child: Material(
  //         color: Colors.transparent,
  //         child: AnimatedBuilder(
  //           animation: controller,
  //           builder: (context, child) {
  //             return Transform.translate(
  //               offset: Offset(animX.value, animY.value),
  //               child: Transform.scale(
  //                 scale: scaleAnim.value,
  //                 child: Opacity(opacity: opacityAnim.value, child: child),
  //               ),
  //             );
  //           },
  //           child: Text(
  //             emojiIcon,
  //             style: TextStyle(fontSize: baseIconSizeSp.sp),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   Overlay.of(context).insert(entry);

  //   controller.forward(from: 0.0).whenComplete(() {
  //     entry?.remove();
  //     controller.dispose();
  //   });
  // }

  // static void showBetweenAnchors({
  //   required BuildContext context,
  //   required GlobalKey startAnchorKey,
  //   required GlobalKey endAnchorKey,
  //   required String emojiIcon,
  //   Duration duration = const Duration(milliseconds: 500),
  //   double baseIconSizeSp = 30.0,
  // }) {
  //   final startBox =
  //       startAnchorKey.currentContext?.findRenderObject() as RenderBox?;
  //   final endBox = endAnchorKey.currentContext?.findRenderObject() as RenderBox?;
  //   if (startBox == null || endBox == null) return;

  //   final startPos = startBox.localToGlobal(Offset.zero);
  //   final endPos = endBox.localToGlobal(Offset.zero);
  //   final startSize = startBox.size;
  //   final endSize = endBox.size;

  //   // Centers of start and end
  //   final Offset p0 = startPos + Offset(startSize.width / 2, startSize.height / 2);
  //   final Offset p2 = endPos + Offset(endSize.width / 2, endSize.height / 2);

  //   // Control point for a subtle arc (above the straight line)
  //   final Offset mid = Offset((p0.dx + p2.dx) / 2, (p0.dy + p2.dy) / 2);
  //   final double arcLift = -60.0; // negative = upwards lift
  //   final Offset p1 = Offset(mid.dx, mid.dy + arcLift);

  //   final controller = AnimationController(
  //     duration: duration,
  //     vsync: Overlay.of(context),
  //   );

  //   final animationT = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

  //   final scaleAnim = TweenSequence<double>([
  //     TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.4), weight: 25),
  //       TweenSequenceItem(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 25),
  //     TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.6), weight: 50),
  //   ]).animate(animationT);

  //   final opacityAnim = TweenSequence<double>([
  //     TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 70),
  //     TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
  //   ]).animate(animationT);

  //   // Bezier function
  //   Offset bezier(double t) {
  //     final mt = 1 - t;
  //     return (p0 * (mt * mt)) + (p1 * (2 * mt * t)) + (p2 * (t * t));
  //   }

  //   OverlayEntry? entry;
  //   entry = OverlayEntry(
  //     builder: (context) {
  //       final t = animationT.value;
  //       final pos = bezier(t);
  //       return Positioned(
  //         left: pos.dx - (baseIconSizeSp.sp / 2),
  //         top: pos.dy - (baseIconSizeSp.sp / 2),
  //         child: Material(
  //           color: Colors.transparent,
  //           child: AnimatedBuilder(
  //             animation: animationT,
  //             builder: (context, child) {
  //               return Transform.scale(
  //                 scale: scaleAnim.value,
  //                 child: Opacity(opacity: opacityAnim.value, child: child),
  //               );
  //             },
  //             child: Text(emojiIcon, style: TextStyle(fontSize: baseIconSizeSp.sp)),
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   Overlay.of(context).insert(entry);
  //   controller.addListener(() {
  //     entry?.markNeedsBuild();
  //   });
  //   controller.forward(from: 0.0).whenComplete(() {
  //     entry?.remove();
  //     controller.dispose();
  //   });
  // }
}
