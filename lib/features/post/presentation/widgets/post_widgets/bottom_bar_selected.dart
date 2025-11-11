import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomBarSelected extends StatelessWidget {
  final List<AssetEntity> selectedAssets;
  final Function(AssetEntity asset) toggleAssetSelection;
  final Future<Uint8List?> Function(AssetEntity, ThumbnailSize)
  getCachedThumbnail;

  const BottomBarSelected({
    super.key,
    required this.selectedAssets,
    required this.toggleAssetSelection,
    required this.getCachedThumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: selectedAssets.isNotEmpty ? 80 : 0,
      color: AppColors.background,
      child: selectedAssets.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: selectedAssets.length,
              itemBuilder: (context, index) {
                final asset = selectedAssets[index];
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: FutureBuilder<Uint8List?>(
                          future: getCachedThumbnail(
                            asset,
                            const ThumbnailSize(120, 120),
                          ),
                          builder: (_, snapshot) {
                            final bytes = snapshot.data;
                            if (bytes == null) {
                              return Container(
                                width: 60.w,
                                height: 60.h,
                                color: Colors.grey[800],
                              );
                            }

                            return Image.memory(
                              bytes,
                              width: 60.w,
                              height: 60.h,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),

                      // Số thứ tự trên ảnh đã chọn
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                            width: 18.w,
                            height: 18.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent,
                            ),

                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Nút xóa
                      Positioned(
                        top: 2,
                        left: 2,
                        child: GestureDetector(
                          onTap: () => toggleAssetSelection(asset),
                          child: Container(
                            width: 18.w,
                            height: 18.h,

                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),

                            child: Icon(
                              CupertinoIcons.xmark,
                              color: Colors.white,
                              size: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : null,
    );
  }
}
