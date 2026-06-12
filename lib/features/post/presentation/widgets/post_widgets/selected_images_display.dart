import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/layout_type.dart';
import 'package:social_app_fe/features/post/presentation/pages/edit_selected_image_page.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_classic.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_column.dart';
import 'package:social_app_fe/shared/component/layout/layout_post_frame.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

class SelectedImagesDisplay extends StatefulWidget {
  final List<dynamic> selectedAssets;
  final VoidCallback? onEdit;
  final Function(List<dynamic>)? onRemove;
  final Function(int index)? onRemoveAtIndex;
  final Function(LayoutType layout)? onChangedLayout;
  final Function(int index, File newFile)? onImageEdited;

  const SelectedImagesDisplay({
    super.key,
    required this.selectedAssets,
    this.onEdit,
    this.onRemove,
    this.onRemoveAtIndex,
    this.onChangedLayout,
    this.onImageEdited,
  });

  @override
  State<SelectedImagesDisplay> createState() => _SelectedImagesDisplayState();
}

class _SelectedImagesDisplayState extends State<SelectedImagesDisplay> {
  LayoutType _currentLayout = LayoutType.classic;
  List<dynamic> _imageFiles = [];
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

    List<dynamic> files = [];
    if (kIsWeb) {
      for (int i = 0; i < widget.selectedAssets.length; i++) {
        final asset = widget.selectedAssets[i];
        if (asset is PlatformFile && asset.bytes != null) {
          files.add(asset);
        }
      }
    } else {
      for (int i = 0; i < widget.selectedAssets.length; i++) {
        final asset = widget.selectedAssets[i];
        if (asset is AssetEntity) {
          final file = await asset.file;
          if (file != null) {
            files.add(file);
          }
        }
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
          context.l10n.postChooseLayout,
          style: TextStyle(
            fontSize: 16.rsp(context),
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _currentLayout = LayoutType.classic;
                widget.onChangedLayout?.call(LayoutType.classic);
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

                SizedBox(width: 8.rs(context)),

                Text(
                  context.l10n.postLayoutClassic,
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
                widget.onChangedLayout?.call(LayoutType.column);
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

                SizedBox(width: 8.rs(context)),

                Text(
                  context.l10n.postLayoutColumn,
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
                widget.onChangedLayout?.call(LayoutType.frame);
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

                SizedBox(width: 8.rs(context)),

                Text(
                  context.l10n.postLayoutFrame,
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
          child: Text(
            context.l10n.commonCancel,
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
    if (_imageFiles.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditSelectedImagePage(
          imageFiles: kIsWeb ? _imageFiles : _imageFiles.whereType<File>().toList(),
          initialIndex: index,
          onAdd: widget.onEdit,
          onRemoveAtIndex: (removeIndex) {
            widget.onRemoveAtIndex?.call(removeIndex);
            if (_imageFiles.isEmpty) {
              Navigator.pop(context);
            }
          },
          onImageEdited: (editedIndex, newFile) {
            widget.onImageEdited?.call(editedIndex, newFile);

            // Also update the local list immediately to reflect the new image
            if (mounted && editedIndex < _imageFiles.length) {
              setState(() {
                _imageFiles[editedIndex] = newFile;
              });
            }
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
      margin: EdgeInsets.symmetric(
        horizontal: 12.rs(context),
        vertical: 8.rsh(context),
      ),
      child: Column(
        children: [
          // Header với số ảnh và options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.l10n.postSelectedPhotos(widget.selectedAssets.length),
                  style: TextStyle(
                    fontSize: 14.rsp(context),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              Row(
                children: [
                  // Layout selector
                  GestureDetector(
                    onTap: _showLayoutOptions,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.rs(context),
                        vertical: 4.rsh(context),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.rsr(context)),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getLayoutIcon(),
                            size: 16.rsp(context),
                            color: AppColors.primary,
                          ),

                          SizedBox(width: 4.rs(context)),

                          Text(
                            _getLayoutName(context),
                            style: TextStyle(
                              fontSize: 12.rsp(context),
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(width: 2.rs(context)),

                          Icon(
                            CupertinoIcons.chevron_down,
                            size: 12.rsp(context),
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 8.rs(context)),

                  // Edit button
                  if (!kIsWeb) ...[
                    GestureDetector(
                      onTap: widget.onEdit,
                      child: Container(
                        padding: EdgeInsets.all(6.rs(context)),
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.rsr(context)),
                        ),
                        child: Icon(
                          Icons.swap_horiz,
                          size: 16.rsp(context),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.rs(context)),
                  ],

                  // Remove button
                  GestureDetector(
                    onTap: () => widget.onRemove?.call(widget.selectedAssets),
                    child: Container(
                      padding: EdgeInsets.all(6.rs(context)),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.rsr(context)),
                      ),
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 16.rsp(context),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.rsh(context)),

          // Images display
          if (_isLoading)
            Container(
              height: 200.rsh(context),
              alignment: Alignment.center,
              child: const CupertinoActivityIndicator(),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              child: Stack(
                children: [
                  _buildLayoutWidget(),

                  if (!kIsWeb)
                    Positioned(
                      top: 10.rsh(context),
                      left: 10.rs(context),
                      child: GestureDetector(
                        onTap: () {
                          _openEditSelectedPage(0);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.rs(context),
                            vertical: 6.rsh(context),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(
                              12.rsr(context),
                            ),
                          ),

                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.textPrimary,
                                size: 16.rsp(context),
                              ),
                              SizedBox(width: 4.rs(context)),
                              Text(
                                context.l10n.postEditCount(
                                  widget.selectedAssets.length,
                                ),
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14.rsp(context),
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

  String _getLayoutName(BuildContext context) {
    switch (_currentLayout) {
      case LayoutType.classic:
        return context.l10n.postLayoutClassic;
      case LayoutType.column:
        return context.l10n.postLayoutColumn;
      case LayoutType.frame:
        return context.l10n.postLayoutFrame;
    }
  }
}
