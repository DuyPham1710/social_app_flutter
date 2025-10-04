import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefreshHeader extends StatelessWidget {
  final Icon icon;
  const CustomRefreshHeader({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      builder: (context, mode) {
        Widget body;

        if (mode == RefreshStatus.idle) {
          // Trạng thái chờ kéo
          body = icon;
        } else if (mode == RefreshStatus.canRefresh) {
          // Kéo đủ độ
          body = icon;
        } else if (mode == RefreshStatus.refreshing) {
          // Loading
          body = const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          );
        } else if (mode == RefreshStatus.completed) {
          // Load xong -> ẩn luôn
          body = const SizedBox.shrink();
        } else {
          body = const SizedBox.shrink();
        }

        return SizedBox(height: 60.0, child: Center(child: body));
      },
    );
  }
}
