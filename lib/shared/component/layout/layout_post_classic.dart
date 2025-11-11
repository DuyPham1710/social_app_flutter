import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

class LayoutPostClassic extends StatelessWidget {
  final List<dynamic> urls;
  final Function(int) onImageTap;

  const LayoutPostClassic({
    super.key,
    required this.urls,
    required this.onImageTap,
  });

  // chưa dùng đến
  List<dynamic> get sortedUrls {
    final List<dynamic> sorted = List.from(urls);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  Widget _buildImageWidget(dynamic imageData) {
    if (imageData is File) {
      return Image.file(imageData, fit: BoxFit.cover, width: double.infinity);
    } else if (imageData is String) {
      return Image.network(
        imageData,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    } else if (imageData != null && imageData.url != null) {
      return Image.network(
        imageData.url,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    } else {
      return Container(
        color: Colors.grey[300],
        child: Icon(Icons.image, color: Colors.grey[600]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    // Không cần sort cho local files vì chúng đã được sắp xếp
    // final orderedUrls = sortedUrls;
    final orderedUrls = urls;

    if (orderedUrls.length == 1) {
      // 1 hình: hiển thị bình thường
      return GestureDetector(
        onTap: () => onImageTap(0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: _buildImageWidget(orderedUrls[0]),
          ),
        ),
      );
    } else if (orderedUrls.length == 2) {
      // 2 hình: ảnh mới đẩy ảnh cũ sang trái
      return AspectRatio(
        aspectRatio: 2.0,
        child: Row(
          children: [
            // Ảnh cũ (ảnh đầu tiên) bị đẩy sang trái
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => onImageTap(0),
                child: _buildImageWidget(orderedUrls[0]),
              ),
            ),

            SizedBox(width: 4.w),

            // Ảnh mới (ảnh thứ hai)
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => onImageTap(1),
                child: _buildImageWidget(orderedUrls[1]),
              ),
            ),
          ],
        ),
      );
    } else {
      // 3+ hình: xuống dòng, layout grid
      return _buildClassicGrid(orderedUrls);
    }
  }

  Widget _buildClassicGrid(List<dynamic> orderedUrls) {
    return Column(
      children: [
        // Dòng đầu: 2 ảnh đầu tiên
        AspectRatio(
          aspectRatio: 2.0,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onImageTap(0),
                  child: _buildImageWidget(orderedUrls[0]),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => onImageTap(1),
                  child: _buildImageWidget(orderedUrls[1]),
                ),
              ),
            ],
          ),
        ),

        if (orderedUrls.length > 2) SizedBox(height: 4.h),

        // Dòng thứ 2: ảnh còn lại
        AspectRatio(
          aspectRatio: 2.0,
          child: Row(children: _buildSecondRowImages(orderedUrls)),
        ),
      ],
    );
  }

  List<Widget> _buildSecondRowImages(List<dynamic> orderedUrls) {
    List<Widget> images = [];
    final maxImagesInSecondRow = orderedUrls.length > 4
        ? 2
        : orderedUrls.length - 2;

    for (int i = 2; i < 2 + maxImagesInSecondRow; i++) {
      // khoảng cách giữa các ảnh
      if (i > 2) images.add(SizedBox(width: 4.w));

      // Nếu là ảnh cuối cùng trong dòng 2 và còn nhiều ảnh hơn => overlay
      if (i == 3 && orderedUrls.length > 4) {
        final remaining = orderedUrls.length - 4;
        images.add(
          Expanded(
            child: GestureDetector(
              onTap: () => onImageTap(i),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImageWidget(orderedUrls[i]),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      //          borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+$remaining',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        images.add(
          Expanded(
            child: GestureDetector(
              onTap: () => onImageTap(i),
              child: _buildImageWidget(orderedUrls[i]),
            ),
          ),
        );
      }
    }

    return images;
  }
}
