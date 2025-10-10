import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  int currentIndex = 0;
  double dragStartX = 0;
  double dragStartY = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _handlePanStart(DragStartDetails details) {
    dragStartX = details.globalPosition.dx;
    dragStartY = details.globalPosition.dy;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final dx = details.globalPosition.dx - dragStartX;
    final dy = details.globalPosition.dy - dragStartY;

    // Vuốt dọc hoặc xéo (lên/xuống hoặc xéo) -> thoát
    if (dy.abs() > 80 && dx.abs() < 100 || (dy.abs() > 80 && dx.abs() > 80)) {
      Navigator.of(context).pop(currentIndex);
      return;
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    // Nếu user kéo nhẹ không đủ để chuyển trang, không làm gì thêm
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.imageUrls.length,
            pageController: _pageController,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.imageUrls[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.5,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: widget.imageUrls[index],
                ),
              );
            },
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            scrollPhysics: const BouncingScrollPhysics(),
          ),
          // Page indicator
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${currentIndex + 1} / ${widget.imageUrls.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
