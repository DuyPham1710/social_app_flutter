import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditSelectedImagePage extends StatefulWidget {
  final List<File> imageFiles;
  final int initialIndex;
  final VoidCallback? onAdd;

  const EditSelectedImagePage({
    super.key,
    required this.imageFiles,
    required this.initialIndex,
    this.onAdd,
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
                  Navigator.pop(context);
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
                    // mở ảnh toàn màn hình khi nhấn
                    //    _showFullScreenImage(context, imageIndex);
                  },
                  child: Stack(
                    children: [
                      Image.file(
                        widget.imageFiles[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),

                      Positioned(
                        top: 10.h,
                        left: 10.w,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: xử lý khi nhấn chỉnh sửa (mở crop, filter, v.v.)
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
                            // TODO: xử lý khi nhấn nút X (xóa ảnh khỏi danh sách)
                            setState(() {
                              widget.imageFiles.removeAt(index);
                            });
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
