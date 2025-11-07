import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/layout_type.dart';
import 'package:social_app_fe/features/post/presentation/pages/edit_selected_image_page.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_classic.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_column.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_frame.dart';
import 'dart:io';

class SelectedImagesDisplay extends StatefulWidget {
  final List<AssetEntity> selectedAssets;
  final VoidCallback? onEdit;
  final Function(List<AssetEntity>)? onRemove;
  final Function(int index)? onRemoveAtIndex;

  const SelectedImagesDisplay({
    super.key,
    required this.selectedAssets,
    this.onEdit,
    this.onRemove,
    this.onRemoveAtIndex,
  });

  @override
  State<SelectedImagesDisplay> createState() => _SelectedImagesDisplayState();
}

class _SelectedImagesDisplayState extends State<SelectedImagesDisplay> {
  LayoutType _currentLayout = LayoutType.classic;
  List<File> _imageFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImageUrls();
  }

  @override
  void didUpdateWidget(SelectedImagesDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedAssets != widget.selectedAssets) {
      _loadImageUrls();
    }
  }

  Future<void> _loadImageUrls() async {
    setState(() {
      _isLoading = true;
    });

    List<File> files = [];
    for (int i = 0; i < widget.selectedAssets.length; i++) {
      final asset = widget.selectedAssets[i];
      final file = await asset.file;
      if (file != null) {
        files.add(file);
      }
    }

    setState(() {
      _imageFiles = files;
      _isLoading = false;
    });
  }

  void _showLayoutOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          'Chọn bố cục',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),

        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _currentLayout = LayoutType.classic;
              });
              Navigator.pop(context);
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.grid,
                  color: _currentLayout == LayoutType.classic
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),

                SizedBox(width: 8.w),

                Text(
                  'Classic',
                  style: TextStyle(
                    color: _currentLayout == LayoutType.classic
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _currentLayout = LayoutType.column;
              });
              Navigator.pop(context);
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.rectangle_3_offgrid,
                  color: _currentLayout == LayoutType.column
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),

                SizedBox(width: 8.w),

                Text(
                  'Column',
                  style: TextStyle(
                    color: _currentLayout == LayoutType.column
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _currentLayout = LayoutType.frame;
              });
              Navigator.pop(context);
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.square_stack_3d_down_right,
                  color: _currentLayout == LayoutType.frame
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),

                SizedBox(width: 8.w),

                Text(
                  'Frame',
                  style: TextStyle(
                    color: _currentLayout == LayoutType.frame
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],

        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Hủy',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  void _onImageTap(int index) {
    _openEditSelectedPage(index);
  }

  void _openEditSelectedPage(int index) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => EditSelectedImagePage(
          imageFiles: _imageFiles,
          initialIndex: index,
          onAdd: widget.onEdit,
          onRemoveAtIndex: (removeIndex) {
            widget.onRemoveAtIndex?.call(removeIndex);
          },
        ),
      ),
    );
  }

  Widget _buildLayoutWidget() {
    if (_imageFiles.isEmpty) return const SizedBox.shrink();

    switch (_currentLayout) {
      case LayoutType.classic:
        return LayoutPostClassic(urls: _imageFiles, onImageTap: _onImageTap);
      case LayoutType.column:
        return LayoutPostColumn(urls: _imageFiles, onImageTap: _onImageTap);
      case LayoutType.frame:
        return LayoutPostFrame(urls: _imageFiles, onImageTap: _onImageTap);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedAssets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        children: [
          // Header với số ảnh và options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.selectedAssets.length} ảnh được chọn',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              Row(
                children: [
                  // Layout selector
                  GestureDetector(
                    onTap: _showLayoutOptions,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getLayoutIcon(),
                            size: 16.sp,
                            color: AppColors.primary,
                          ),

                          SizedBox(width: 4.w),

                          Text(
                            _getLayoutName(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(width: 2.w),

                          Icon(
                            CupertinoIcons.chevron_down,
                            size: 12.sp,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Edit button
                  GestureDetector(
                    onTap: widget.onEdit,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.swap_horiz,
                        size: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Remove button
                  GestureDetector(
                    onTap: () => widget.onRemove?.call(widget.selectedAssets),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 16.sp,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Images display
          if (_isLoading)
            Container(
              height: 200.h,
              alignment: Alignment.center,
              child: const CupertinoActivityIndicator(),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                children: [
                  _buildLayoutWidget(),

                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: GestureDetector(
                      onTap: () {
                        _openEditSelectedPage(0);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12.r),
                        ),

                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: AppColors.textPrimary,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Chỉnh sửa (${widget.selectedAssets.length})',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _getLayoutIcon() {
    switch (_currentLayout) {
      case LayoutType.classic:
        return CupertinoIcons.grid;
      case LayoutType.column:
        return CupertinoIcons.rectangle_3_offgrid;
      case LayoutType.frame:
        return CupertinoIcons.square_stack_3d_down_right;
    }
  }

  String _getLayoutName() {
    switch (_currentLayout) {
      case LayoutType.classic:
        return 'Classic';
      case LayoutType.column:
        return 'Column';
      case LayoutType.frame:
        return 'Frame';
    }
  }
}
