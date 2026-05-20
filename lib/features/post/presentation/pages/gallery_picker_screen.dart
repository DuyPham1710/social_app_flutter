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

  // Thêm variables cho folder picker
  List<AssetPathEntity> _paths = [];
  AssetPathEntity? _currentPath;

  // Cache cho thumbnails để tránh reload
  final Map<String, Uint8List> _thumbnailCache = {};

  @override
  void initState() {
    super.initState();
    selectedAssets = List.from(widget.selectedAssets);
    _fetchPathsAndAssets();
  }

  Future<void> _fetchPathsAndAssets() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) return;

    if (ps.isAuth) {
      // Lấy tất cả các thư mục bao gồm cả ảnh và video
      // Sắp xếp theo thời gian cập nhật mới nhất
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        filterOption: FilterOptionGroup(
          orders: [OrderOption(type: OrderOptionType.updateDate, asc: false)],
        ),
      );

      if (paths.isNotEmpty) {
        if (mounted) {
          setState(() {
            _paths = paths;
            _currentPath = paths.firstWhere(
              (path) =>
                  path.name.toLowerCase().contains('all') ||
                  path.name.toLowerCase().contains('recent') ||
                  path.name.toLowerCase().contains('tất cả'),
              orElse: () => paths.first,
            );
          });
          await _loadAssetsFromPath(_currentPath!);
        }
        return;
      }
      setState(() => isLoading = false);
    } else {
      setState(() {
        isLoading = false;
      });
      PhotoManager.openSetting();
    }
  }

  Future<void> _loadAssetsFromPath(AssetPathEntity path) async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final entities = await path.getAssetListPaged(
      page: 0,
      size: 200, // Load nhiều hơn để có đủ ảnh
    );

    // Sắp xếp theo thời gian mới nhất
    entities.sort((a, b) {
      final dateA = a.createDateTime;
      final dateB = b.createDateTime;
      return dateB.compareTo(dateA); // Mới nhất trước
    });

    if (mounted) {
      setState(() {
        mediaList = entities;
        isLoading = false;
        _currentPath = path;
      });
    }
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

  Future<void> _showFolderPicker() async {
    if (_paths.isEmpty) return;

    final selectedPath = await showModalBottomSheet<AssetPathEntity>(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Chọn thư mục",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _paths.length,
                itemBuilder: (context, index) {
                  final path = _paths[index];
                  final isSelected = path.id == _currentPath?.id;
                  return ListTile(
                    leading: Icon(
                      CupertinoIcons.folder,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      path.name,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            CupertinoIcons.check_mark,
                            color: AppColors.primary,
                          )
                        : null,
                    subtitle: FutureBuilder<int>(
                      future: path.assetCountAsync,
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        return Text(
                          "$count mục",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.pop(context, path);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedPath != null && selectedPath.id != _currentPath?.id) {
      await _loadAssetsFromPath(selectedPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        middle: GestureDetector(
          onTap: _showFolderPicker,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentPath?.name ?? 'Thư viện ảnh',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              SizedBox(width: 4.w),
              Icon(
                CupertinoIcons.chevron_down,
                color: AppColors.textPrimary,
                size: 16,
              ),
            ],
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.xmark, color: AppColors.textPrimary),
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
                child: Icon(
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
