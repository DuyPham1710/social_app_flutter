import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/utils/video_util.dart';
import 'package:social_app_fe/features/post/presentation/pages/video_player_screen.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';

class EditSelectedImagePage extends StatefulWidget {
  final List<File> imageFiles;
  final int initialIndex;
  final VoidCallback? onAdd;
  final Function(int index)? onRemoveAtIndex;
  final Function(int index, File newFile)? onImageEdited;

  const EditSelectedImagePage({
    super.key,
    required this.imageFiles,
    required this.initialIndex,
    this.onAdd,
    this.onRemoveAtIndex,
    this.onImageEdited,
  });

  @override
  State<EditSelectedImagePage> createState() => _EditSelectedImagePageState();
}

class _EditSelectedImagePageState extends State<EditSelectedImagePage> {
  late ItemScrollController _scrollController = ItemScrollController();
  List<TextEditingController> _captionControllers = [];

  @override
  void initState() {
    super.initState();
    _captionControllers = List.generate(
      widget.imageFiles.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final controller in _captionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Method to show full screen video player
  void _showVideoPlayer(File videoFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoData: videoFile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialIndex = widget.initialIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: AppColors.textPrimary,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Chỉnh sửa',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,

        actions: [
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // Return danh sách files đã được edit
                  Navigator.pop(context, widget.imageFiles);
                },
                child: Text(
                  'Xong',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(width: 12.w),
            ],
          ),
        ],
      ),

      body: ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        initialScrollIndex: initialIndex,
        itemCount: widget.imageFiles.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.imageFiles.length) {
            return _buildButtonAddImage();
          }

          return Column(
            children: [
              Divider(color: AppColors.divider),

              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: GestureDetector(
                  onTap: () {
                    // Check if it's a video or image and handle accordingly
                    if (VideoUtil.isVideo(widget.imageFiles[index])) {
                      _showVideoPlayer(widget.imageFiles[index]);
                    } else {
                      // mở ảnh toàn màn hình khi nhấn
                      //    _showFullScreenImage(context, imageIndex);
                    }
                  },
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          // Check if it's video or image and display accordingly
                          VideoUtil.isVideo(widget.imageFiles[index])
                              ? buildVideoThumbnail(widget.imageFiles[index].path)
                              : Image.file(
                                  widget.imageFiles[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  key: ValueKey(
                                    '${widget.imageFiles[index].path}_${widget.imageFiles[index].lastModifiedSync().millisecondsSinceEpoch}',
                                  ),
                                ),
                        ],
                      ),

                      Positioned(
                        top: 10.h,
                        left: 10.w,
                        child: VideoUtil.isVideo(widget.imageFiles[index])
                            ? Container(
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
                                      Icons.videocam,
                                      color: AppColors.textSecondary,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Video',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  try {
                                    // Đọc dữ liệu byte từ ảnh gốc
                                    final imageBytes = await widget
                                        .imageFiles[index]
                                        .readAsBytes();

                                    // Mở trình chỉnh sửa ảnh
                                    final editedImage = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ImageEditor(image: imageBytes),
                                      ),
                                    );

                                    // Nếu người dùng đã chỉnh sửa xong và quay lại
                                    if (editedImage != null &&
                                        editedImage is Uint8List) {
                                      // Tạo tên file mới với timestamp để tránh cache
                                      final timestamp =
                                          DateTime.now().millisecondsSinceEpoch;
                                      final directory =
                                          widget.imageFiles[index].parent;
                                      final fileName = widget
                                          .imageFiles[index]
                                          .path
                                          .split('/')
                                          .last;
                                      final nameWithoutExt = fileName
                                          .split('.')
                                          .first;
                                      final extension = fileName
                                          .split('.')
                                          .last;
                                      final newPath =
                                          '${directory.path}/${nameWithoutExt}_edited_$timestamp.$extension';

                                      final newFile = File(newPath);

                                      // Ghi ảnh đã chỉnh sửa vào file mới
                                      await newFile.writeAsBytes(editedImage);

                                      // Clear image cache để force reload
                                      imageCache.clear();
                                      imageCache.clearLiveImages();

                                      setState(() {
                                        // Cập nhật với file mới
                                        widget.imageFiles[index] = newFile;
                                      });
                                      widget.onImageEdited?.call(
                                        index,
                                        newFile,
                                      );
                                    }
                                  } catch (e) {
                                    print("Lỗi khi chỉnh sửa ảnh: $e");
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.background.withOpacity(
                                      0.8,
                                    ),
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
                                        'Chỉnh sửa',
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

                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.imageFiles.removeAt(index);
                            });
                            widget.onRemoveAtIndex?.call(index);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: AppColors.textPrimary,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ),

                      /// Số thứ tự ảnh
                      Positioned(
                        right: 8.w,
                        bottom: 8.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${index + 1}/${widget.imageFiles.length}',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              _buildCaptionInput(index),
            ],
          );
        },
      ),
    );
  }

  Padding _buildButtonAddImage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 24.h),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.background,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.primary, width: 2),
          ),
          elevation: 0,
        ),
        onPressed: widget.onAdd,
        icon: Icon(
          CupertinoIcons.photo_on_rectangle,
          color: AppColors.primary,
          size: 22.sp,
        ),
        label: Text(
          'Thêm ảnh/video',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCaptionInput(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      child: TextField(
        controller: _captionControllers[index],
        style: TextStyle(color: AppColors.textPrimary, fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: 'Thêm chú thích...',
          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
          filled: true,
          fillColor: AppColors.background.withOpacity(0.5),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
        ),
        maxLines: null,
      ),
    );
  }
}
