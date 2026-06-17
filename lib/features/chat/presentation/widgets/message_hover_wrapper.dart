import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class MessageHoverWrapper extends StatefulWidget {
  final Widget child;
  final bool fromMe;
  final VoidCallback? onReact;
  final VoidCallback? onReply;
  final VoidCallback? onMore;
  final bool isDeleted;

  const MessageHoverWrapper({
    required this.child,
    required this.fromMe,
    this.onReact,
    this.onReply,
    this.onMore,
    required this.isDeleted,
  });

  @override
  State<MessageHoverWrapper> createState() => _MessageHoverWrapperState();
}

class _MessageHoverWrapperState extends State<MessageHoverWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (!ResponsiveHelper.isWebOrDesktop) return widget.child;

    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: widget.fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.fromMe && _isHovered && !widget.isDeleted)
            _buildHoverMenu(),
          if (widget.fromMe && _isHovered && !widget.isDeleted)
            SizedBox(width: 8.w),

          Flexible(child: widget.child),

          if (!widget.fromMe && _isHovered && !widget.isDeleted)
            SizedBox(width: 8.w),
          if (!widget.fromMe && _isHovered && !widget.isDeleted)
            _buildHoverMenu(),
        ],
      ),
    );
  }

  Widget _buildHoverMenu() {
    final icons = [
      _buildHoverIcon(Icons.sentiment_satisfied_alt, widget.onReact),
      SizedBox(width: 4.w),
      _buildHoverIcon(Icons.reply, widget.onReply),
      SizedBox(width: 4.w),
      _buildHoverIcon(Icons.more_vert, widget.onMore),
    ];

    if (widget.fromMe) {
      icons.setAll(0, icons.reversed.toList());
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons,
    );
  }

  Widget _buildHoverIcon(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(icon, size: 20.sp, color: AppColors.textSecondary),
      ),
    );
  }
}
