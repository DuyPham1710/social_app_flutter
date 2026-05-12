import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:social_app_fe/core/utils/video_util.dart';
import 'package:social_app_fe/shared/component/video_player_widget.dart';

class LayoutPostFrame extends StatelessWidget {
  final List<dynamic> urls;
  final Function(int) onImageTap;

  const LayoutPostFrame({
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
    Widget mediaWidget;

    if (imageData is File) {
      // Check if it's a video file first
      if (VideoUtil.isVideo(imageData)) {
        // For video files, show video player
        mediaWidget = VideoPlayerWidget(
          videoUrl: imageData.path,
        );
      } else {
        // For image files, show the image
        mediaWidget = Image.file(
          imageData,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(Icons.broken_image, color: Colors.grey[600]),
            );
          },
        );
      }
    } else if (imageData is String) {
      if (VideoUtil.isVideo(imageData)) {
        // For video URLs, show video player
        mediaWidget = VideoPlayerWidget(
          videoUrl: imageData,
        );
      } else {
        mediaWidget = Image.network(
          imageData,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(Icons.broken_image, color: Colors.grey[600]),
            );
          },
        );
      }
    } else if (imageData != null && imageData.url != null) {
      if (VideoUtil.isVideo(imageData)) {
        mediaWidget = VideoPlayerWidget(
          videoUrl: imageData.url,
        );
      } else {
        mediaWidget = Image.network(
          imageData.url,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(Icons.broken_image, color: Colors.grey[600]),
            );
          },
        );
      }
    } else {
      mediaWidget = Container(
        color: Colors.grey[300],
        child: Icon(Icons.image, color: Colors.grey[600]),
      );
    }

    // If it's a video, add play icon overlay
    // if (VideoUtil.isVideo(imageData)) {
    //   return Stack(
    //     fit: StackFit.expand,
    //     children: [
    //       mediaWidget,
    //       Container(
    //         color: Colors.black.withOpacity(0.3),
    //         child: Center(
    //           child: Icon(
    //             Icons.play_circle_filled,
    //             color: Colors.white,
    //             size: 48.sp,
    //           ),
    //         ),
    //       ),
    //     ],
    //   );
    // }

    return mediaWidget;
  }

  // Bộ màu pastel dễ nhìn cho background
  static final List<Color> _frameColors = [
    Color(0xFFFFE5E5), // Pastel Pink
    Color(0xFFE5F3FF), // Pastel Blue
    Color(0xFFE5FFE5), // Pastel Green
    Color(0xFFFFF5E5), // Pastel Orange
    Color(0xFFF5E5FF), // Pastel Purple
    Color(0xFFFFFFE5), // Pastel Yellow
    Color(0xFFFFE5F5), // Pastel Rose
    Color(0xFFE5FFFF), // Pastel Cyan
    Color(0xFFFFF0E5), // Pastel Peach
    Color(0xFFE5F0FF), // Pastel Sky
  ];

  Color get randomFrameColor {
    // Sử dụng hash của paths để đảm bảo cùng 1 post luôn có cùng màu
    final seed = urls
        .map((e) => e is File ? e.path : e.toString())
        .join()
        .hashCode;
    final index = seed.abs() % _frameColors.length;
    return _frameColors[index];
  }

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    // Không cần sort cho local files vì chúng đã được sắp xếp
    // final orderedUrls = sortedUrls;
    final orderedUrls = urls;

    return _buildFrameLayout(orderedUrls);
  }

  Widget _buildFrameLayout(List<dynamic> orderedUrls) {
    final frameColor = randomFrameColor;

    if (orderedUrls.length == 1) {
      // 1 ảnh: hiển thị đơn giản với frame
      return Container(
        color: frameColor,
        padding: EdgeInsets.all(12.w),
        child: GestureDetector(
          onTap: () => onImageTap(0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _buildImageWidget(orderedUrls[0]),
            ),
          ),
        ),
      );
    } else if (orderedUrls.length == 2) {
      // 2 ảnh: layout dọc như column
      return SizedBox(
        height: 280.h,
        child: Container(
          color: frameColor,

          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onImageTap(0),
                  child: SizedBox(
                    height: 250.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: _buildImageWidget(orderedUrls[0]),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.h),

              Expanded(
                child: GestureDetector(
                  onTap: () => onImageTap(1),
                  child: SizedBox(
                    height: 250.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: _buildImageWidget(orderedUrls[1]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 3+ ảnh: 2 cột với hiệu ứng dịch chuyển
      return Container(
        color: frameColor,

        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cột 1: dịch lên trên
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: _buildColumn1(orderedUrls),
              ),
            ),

            SizedBox(width: 10.w),
            // Cột 2: dịch xuống dưới
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: _buildColumn2(orderedUrls),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildColumn1(List<dynamic> orderedUrls) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onImageTap(0),
          child: SizedBox(
            height: 250.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _buildImageWidget(orderedUrls[0]),
            ),
          ),
        ),

        SizedBox(height: 10.h),

        GestureDetector(
          onTap: () => onImageTap(1),
          child: SizedBox(
            height: 250.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _buildImageWidget(orderedUrls[1]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumn2(List<dynamic> orderedUrls) {
    final maxImages = orderedUrls.length > 5 ? 5 : orderedUrls.length;

    return Column(
      children: [
        if (orderedUrls.length == 3)
          GestureDetector(
            onTap: () => onImageTap(2),
            child: SizedBox(
              height: 300.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _buildImageWidget(orderedUrls[2]),
              ),
            ),
          )
        else if (maxImages >= 3)
          GestureDetector(
            onTap: () => onImageTap(2),
            child: SizedBox(
              height: 180.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _buildImageWidget(orderedUrls[2]),
              ),
            ),
          ),
        if (maxImages >= 4) ...[
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => onImageTap(3),
            child: SizedBox(
              height: 180.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _buildImageWidget(orderedUrls[3]),
              ),
            ),
          ),
        ],
        if (maxImages >= 5) ...[
          SizedBox(height: 10.h),
          orderedUrls.length > 5
              ? _buildOverlayImage(orderedUrls[4], orderedUrls.length - 5)
              : GestureDetector(
                  onTap: () => onImageTap(4),
                  child: SizedBox(
                    height: 180.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: _buildImageWidget(orderedUrls[4]),
                    ),
                  ),
                ),
        ],
      ],
    );
  }

  Widget _buildOverlayImage(dynamic imageData, int remaining) {
    return GestureDetector(
      onTap: () => onImageTap(4),
      child: SizedBox(
        height: 180.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              height: 180.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _buildImageWidget(imageData),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.r),
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
    );
  }
}
