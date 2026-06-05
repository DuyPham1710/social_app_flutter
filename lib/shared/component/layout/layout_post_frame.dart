import 'package:flutter/material.dart';
import 'dart:io';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/utils/video_util.dart';
import 'package:social_app_fe/shared/component/video_player_widget.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';

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

  Widget _buildImageWidget(dynamic imageData, int index) {
    Widget mediaWidget;

    if (imageData is File) {
      // Check if it's a video file first
      if (VideoUtil.isVideo(imageData)) {
        if (urls.length != 1) {
          return _buildVideoPreviewPlaceholder(imageData.path);
        }
        // For video files, show video player
        mediaWidget = VideoPlayerWidget(
          videoUrl: imageData.path,
          onOpenDetail: () => onImageTap(index),
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
        if (urls.length != 1) {
          return _buildVideoPreviewPlaceholder(imageData);
        }
        // For video URLs, show video player
        mediaWidget = VideoPlayerWidget(
          videoUrl: imageData,
          onOpenDetail: () => onImageTap(index),
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
        if (urls.length != 1) {
          return _buildVideoPreviewPlaceholder(imageData.url);
        }
        mediaWidget = VideoPlayerWidget(
          videoUrl: imageData.url,
          onOpenDetail: () => onImageTap(index),
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

    return mediaWidget;
  }

  Widget _buildVideoPreviewPlaceholder(String videoSource) {
    return buildVideoThumbnail(videoSource);
  }

  // Bộ màu pastel dễ nhìn cho background
  static final List<Color> _frameColors = [
    const Color(0xFFFFE5E5), // Pastel Pink
    const Color(0xFFE5F3FF), // Pastel Blue
    const Color(0xFFE5FFE5), // Pastel Green
    const Color(0xFFFFF5E5), // Pastel Orange
    const Color(0xFFF5E5FF), // Pastel Purple
    const Color(0xFFFFFFE5), // Pastel Yellow
    const Color(0xFFFFE5F5), // Pastel Rose
    const Color(0xFFE5FFFF), // Pastel Cyan
    const Color(0xFFFFF0E5), // Pastel Peach
    const Color(0xFFE5F0FF), // Pastel Sky
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

    final orderedUrls = urls;

    return _buildFrameLayout(context, orderedUrls);
  }

  Widget _buildFrameLayout(BuildContext context, List<dynamic> orderedUrls) {
    final frameColor = randomFrameColor;

    if (orderedUrls.length == 1) {
      // 1 ảnh: hiển thị đơn giản với frame
      return Container(
        color: frameColor,
        padding: EdgeInsets.all(12.rs(context)),
        child: GestureDetector(
          onTap: () => onImageTap(0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.rsr(context)),
              child: _buildImageWidget(orderedUrls[0], 0),
            ),
          ),
        ),
      );
    } else if (orderedUrls.length == 2) {
      // 2 ảnh: layout dọc như column
      return SizedBox(
        height: 280.rsh(context),
        child: Container(
          color: frameColor,
          padding: EdgeInsets.all(12.rs(context)),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onImageTap(0),
                  child: SizedBox(
                    height: 250.rsh(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.rsr(context)),
                      child: _buildImageWidget(orderedUrls[0], 0),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.rs(context)),

              Expanded(
                child: GestureDetector(
                  onTap: () => onImageTap(1),
                  child: SizedBox(
                    height: 250.rsh(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.rsr(context)),
                      child: _buildImageWidget(orderedUrls[1], 1),
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
        padding: EdgeInsets.all(12.rs(context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cột 1: dịch lên trên
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: _buildColumn1(context, orderedUrls),
              ),
            ),

            SizedBox(width: 10.rs(context)),
            // Cột 2: dịch xuống dưới
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 40.rsh(context)),
                child: _buildColumn2(context, orderedUrls),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildColumn1(BuildContext context, List<dynamic> orderedUrls) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onImageTap(0),
          child: SizedBox(
            height: 250.rsh(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.rsr(context)),
              child: _buildImageWidget(orderedUrls[0], 0),
            ),
          ),
        ),

        SizedBox(height: 10.rsh(context)),

        GestureDetector(
          onTap: () => onImageTap(1),
          child: SizedBox(
            height: 250.rsh(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.rsr(context)),
              child: _buildImageWidget(orderedUrls[1], 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumn2(BuildContext context, List<dynamic> orderedUrls) {
    final maxImages = orderedUrls.length > 5 ? 5 : orderedUrls.length;

    return Column(
      children: [
        if (orderedUrls.length == 3)
          GestureDetector(
            onTap: () => onImageTap(2),
            child: SizedBox(
              height: 300.rsh(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.rsr(context)),
                child: _buildImageWidget(orderedUrls[2], 2),
              ),
            ),
          )
        else if (maxImages >= 3)
          GestureDetector(
            onTap: () => onImageTap(2),
            child: SizedBox(
              height: 180.rsh(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.rsr(context)),
                child: _buildImageWidget(orderedUrls[2], 2),
              ),
            ),
          ),
        if (maxImages >= 4) ...[
          SizedBox(height: 10.rsh(context)),
          GestureDetector(
            onTap: () => onImageTap(3),
            child: SizedBox(
              height: 180.rsh(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.rsr(context)),
                child: _buildImageWidget(orderedUrls[3], 3),
              ),
            ),
          ),
        ],
        if (maxImages >= 5) ...[
          SizedBox(height: 10.rsh(context)),
          orderedUrls.length > 5
              ? _buildOverlayImage(
                  context,
                  orderedUrls[4],
                  orderedUrls.length - 5,
                )
              : GestureDetector(
                  onTap: () => onImageTap(4),
                  child: SizedBox(
                    height: 180.rsh(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.rsr(context)),
                      child: _buildImageWidget(orderedUrls[4], 4),
                    ),
                  ),
                ),
        ],
      ],
    );
  }

  Widget _buildOverlayImage(
    BuildContext context,
    dynamic imageData,
    int remaining,
  ) {
    return GestureDetector(
      onTap: () => onImageTap(4),
      child: SizedBox(
        height: 180.rsh(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              height: 180.rsh(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.rsr(context)),
                child: _buildImageWidget(imageData, 4),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8.rsr(context)),
              ),
              alignment: Alignment.center,
              child: Text(
                '+$remaining',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.rsp(context),
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
