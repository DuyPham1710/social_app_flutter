import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_info_snackBar.dart';
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
  final FocusNode _focusNode = FocusNode();
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.rsr(context)),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.rsh(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.download, color: AppColors.textPrimary),
                title: Text(
                  context.l10n.storySavePhoto,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.rsp(context),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _saveImageToGallery(imageUrl);
                },
              ),
              SizedBox(height: 10.rsh(context)),
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
          showInfoSnackBar(
            context,
            context.l10n.commonSavePhotoPermissionMessage,
          );
        }
        return;
      }

      // Hiển thị loading
      if (mounted) {
        showInfoSnackBar(context, context.l10n.messageDownloadingPhoto);
      }

      // Download ảnh
      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final fileName = imageUrl.split('/').last;
      final filePath = '${tempDir.path}/$fileName';

      await dio.download(imageUrl, filePath);

      // Lưu vào gallery
      await PhotoManager.editor.saveImageWithPath(
        filePath,
        title: 'image_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Xóa file tạm
      final tempFile = File(filePath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      if (mounted) {
        showSuccessSnackBar(context, context.l10n.messageSavePhotoSuccess);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, context.l10n.messageSavePhotoError);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goToPreviousImage() {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextImage() {
    if (currentIndex < widget.imageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showArrows =
        ResponsiveHelper.isWebOrDesktop && widget.imageUrls.length > 1;
    final bool showCloseButton = ResponsiveHelper.isWebOrDesktop;

    Widget body = Stack(
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
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${currentIndex + 1} / ${widget.imageUrls.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

        // Close button (Web/Desktop)
        if (showCloseButton)
          Positioned(
            top: 20,
            right: 20,
            child: Material(
              color: Colors.black.withValues(alpha: 0.5),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Đóng',
                hoverColor: Colors.transparent,
              ),
            ),
          ),

        // Left arrow (Web/Desktop)
        if (showArrows && currentIndex > 0)
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Material(
                color: Colors.black.withValues(alpha: 0.5),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: _goToPreviousImage,
                  tooltip: 'Ảnh trước',
                ),
              ),
            ),
          ),

        // Right arrow (Web/Desktop)
        if (showArrows && currentIndex < widget.imageUrls.length - 1)
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Material(
                color: Colors.black.withValues(alpha: 0.5),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: _goToNextImage,
                  tooltip: 'Ảnh tiếp theo',
                ),
              ),
            ),
          ),
      ],
    );

    if (ResponsiveHelper.isWebOrDesktop) {
      body = Focus(
        autofocus: true,
        focusNode: _focusNode,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape) {
              Navigator.of(context).pop();
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _goToPreviousImage();
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _goToNextImage();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Scaffold(backgroundColor: Colors.black, body: body),
      );
    }

    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onLongPress: () {
        _showSaveImageOptions(widget.imageUrls[currentIndex]);
      },
      behavior: HitTestBehavior.opaque,
      child: body,
    );
  }
}
