import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/bottom_bar_selected.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/grid_image_item.dart';

class GalleryPickerScreen extends StatefulWidget {
  final List<AssetEntity> selectedAssets;
  final VoidCallback? openCamera;
  const GalleryPickerScreen({
    super.key,
    required this.selectedAssets,
    this.openCamera,
  });

  @override
  State<GalleryPickerScreen> createState() => _GalleryPickerScreenState();
}

class _GalleryPickerScreenState extends State<GalleryPickerScreen> {
  List<AssetEntity> mediaList = [];
  List<AssetEntity> selectedAssets = [];
  bool isLoading = true;

  // Cache cho thumbnails để tránh reload
  final Map<String, Uint8List> _thumbnailCache = {};

  @override
  void initState() {
    super.initState();
    selectedAssets = List.from(widget.selectedAssets);
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.common, // ảnh + video
      onlyAll: true,
    );

    final recent = albums.first;
    final media = await recent.getAssetListPaged(page: 0, size: 100);

    setState(() {
      mediaList = media;
      isLoading = false;
    });
  }

  Future<Uint8List?> _getCachedThumbnail(
    AssetEntity asset,
    ThumbnailSize size,
  ) async {
    final cacheKey = '${asset.id}_${size.width}_${size.height}';

    if (_thumbnailCache.containsKey(cacheKey)) {
      return _thumbnailCache[cacheKey];
    }

    final thumbnail = await asset.thumbnailDataWithSize(size);
    if (thumbnail != null) {
      _thumbnailCache[cacheKey] = thumbnail;
    }

    return thumbnail;
  }

  void _toggleAssetSelection(AssetEntity asset) {
    setState(() {
      if (selectedAssets.contains(asset)) {
        selectedAssets.remove(asset);
      } else {
        selectedAssets.add(asset);
      }
    });
  }

  int _getAssetIndex(AssetEntity asset) {
    return selectedAssets.indexOf(asset) + 1;
  }

  bool _isAssetSelected(AssetEntity asset) {
    return selectedAssets.contains(asset);
  }

  // Future<void> _openCamera() async {
  //   try {
  //     // Check camera permissions first
  //     final hasPermissions = await CameraHelper.requestCameraPermissions();

  //     if (!hasPermissions) {
  //       if (mounted) {
  //         // Show permission denied dialog
  //         showCupertinoDialog(
  //           context: context,
  //           builder: (context) => CupertinoAlertDialog(
  //             title: const Text('Quyền truy cập Camera'),
  //             content: const Text(
  //               'Ứng dụng cần quyền truy cập camera và microphone để chụp ảnh và quay video.',
  //             ),

  //             actions: [
  //               CupertinoDialogAction(
  //                 child: const Text('OK'),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //       return;
  //     }

  //     final result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const CameraScreen()),
  //     );

  //     if (result != null && result is Map<String, dynamic>) {
  //       // Handle camera result
  //       print('Camera result: $result');
  //       // You can process the captured photo/video here
  //       // For example, convert to AssetEntity and add to selectedAssets
  //     }
  //   } catch (e) {
  //     print('Error opening camera: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        middle: const Text(
          'Thư viện ảnh',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.xmark, color: AppColors.textPrimary),
        ),
        trailing: selectedAssets.isNotEmpty
            ? GestureDetector(
                onTap: () => Navigator.pop(context, selectedAssets),

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Text(
                    'Tiếp (${selectedAssets.length})',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: widget.openCamera,
                child: const Icon(
                  CupertinoIcons.camera,
                  color: AppColors.textPrimary,
                ),
              ),
      ),

      child: SafeArea(
        child: isLoading
            ? const Center(
                child: CupertinoActivityIndicator(color: Colors.white),
              )
            : Column(
                children: [
                  // Grid view của tất cả ảnh
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(2),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                          ),
                      itemCount: mediaList.length,
                      itemBuilder: (context, index) {
                        final asset = mediaList[index];
                        return GridImageItem(
                          key: ValueKey(asset.id),
                          asset: asset,
                          isSelected: _isAssetSelected(asset),
                          selectedIndex: _isAssetSelected(asset)
                              ? _getAssetIndex(asset)
                              : 0,
                          onTap: () => _toggleAssetSelection(asset),
                          getCachedThumbnail: _getCachedThumbnail,
                        );
                      },
                    ),
                  ),

                  // Bottom bar hiển thị ảnh đã chọn
                  BottomBarSelected(
                    selectedAssets: selectedAssets,
                    toggleAssetSelection: _toggleAssetSelection,
                    getCachedThumbnail: _getCachedThumbnail,
                  ),
                ],
              ),
      ),
    );
  }
}
