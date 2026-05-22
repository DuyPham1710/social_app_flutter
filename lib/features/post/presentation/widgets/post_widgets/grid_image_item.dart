import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class GridImageItem extends StatefulWidget {
  final AssetEntity asset;
  final bool isSelected;
  final int selectedIndex;
  final VoidCallback onTap;
  final Future<Uint8List?> Function(AssetEntity, ThumbnailSize)
  getCachedThumbnail;

  const GridImageItem({
    super.key,
    required this.asset,
    required this.isSelected,
    required this.selectedIndex,
    required this.onTap,
    required this.getCachedThumbnail,
  });

  @override
  State<GridImageItem> createState() => _GridImageItemState();
}

class _GridImageItemState extends State<GridImageItem>
    with SingleTickerProviderStateMixin {
  Uint8List? _thumbnailBytes;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadThumbnail();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadThumbnail() async {
    final bytes = await widget.getCachedThumbnail(
      widget.asset,
      const ThumbnailSize(200, 200),
    );
    if (mounted) {
      setState(() {
        _thumbnailBytes = bytes;
      });
    }
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_thumbnailBytes != null)
              Image.memory(_thumbnailBytes!, fit: BoxFit.cover)
            else
              const ColoredBox(color: Colors.black12),

            // Animated overlay khi được chọn
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: widget.isSelected
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.transparent,
            ),

            // Icon video
            if (widget.asset.type == AssetType.video)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    CupertinoIcons.video_camera_solid,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),

            // Animated circle với số thứ tự
            Positioned(
              top: 4,
              right: 4,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? AppColors.primary
                      : Colors.transparent,
                  border: Border.all(color: Colors.white, width: 1),
                ),

                child: widget.isSelected
                    ? Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              '${widget.selectedIndex}',
                              key: ValueKey(widget.selectedIndex),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
