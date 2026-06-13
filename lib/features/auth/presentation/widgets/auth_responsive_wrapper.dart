import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class AuthResponsiveWrapper extends StatelessWidget {
  final Widget child;
  const AuthResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return child;
    }

    // On Web/Desktop
    return Container(
      color: AppColors.background, // outer page background
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
          child: Container(
            width: 420,
            decoration: BoxDecoration(
              color: AppColors.background, // card background
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.divider.withOpacity(0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ScrollConfiguration(
                behavior: const NoScrollbarScrollBehavior(),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoScrollbarScrollBehavior extends ScrollBehavior {
  const NoScrollbarScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
