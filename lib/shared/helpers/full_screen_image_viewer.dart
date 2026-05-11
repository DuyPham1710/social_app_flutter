import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final Function(int)? onImageChanged;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
    this.onImageChanged,
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
      Navigator.of(context).pop();
      return;
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    // Nếu user kéo nhẹ không đủ để chuyển trang, không làm gì thêm
  }

  void _showSaveImageOptions(String imageUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.download, color: AppColors.textPrimary),
                title: Text(
                  'Lưu ảnh',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _saveImageToGallery(imageUrl);
                },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveImageToGallery(String imageUrl) async {
    try {
      // Kiểm tra và xin quyền
      PermissionStatus status;
      if (Platform.isIOS) {
        status = await Permission.photos.request();
      } else {
        if (Platform.isAndroid) {
          if (await Permission.photos.isGranted ||
              await Permission.photos.request().isGranted) {
            status = PermissionStatus.granted;
          } else {
            status = await Permission.storage.request();
          }
        } else {
          status = await Permission.storage.request();
        }
      }

      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cần quyền truy cập ảnh để lưu ảnh'),
            ),
          );
        }
        return;
      }

      // Hiển thị loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đang tải ảnh...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      // Download ảnh
      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final fileName = imageUrl.split('/').last;
      final filePath = '${tempDir.path}/$fileName';

      await dio.download(imageUrl, filePath);

      // Lưu vào gallery
      final savedAsset = await PhotoManager.editor.saveImageWithPath(
        filePath,
        title: 'image_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Xóa file tạm
      final tempFile = File(filePath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      if (mounted) {
        showSuccessSnackBar(context, 'Đã lưu ảnh vào thư viện');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Lỗi khi lưu ảnh: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onLongPress: () {
        _showSaveImageOptions(widget.imageUrls[currentIndex]);
      },
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
              widget.onImageChanged?.call(index);
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
