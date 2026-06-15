import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/utils/video_util.dart';
import 'package:social_app_fe/shared/component/video_player_widget.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';

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

  Widget _buildImageWidget(dynamic imageData, int index) {
    Widget mediaWidget;

    if (imageData is File) {
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
    } else if (imageData is Uint8List) {
      mediaWidget = Image.memory(
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
    } else if (imageData is PlatformFile) {
      if (VideoUtil.isVideo(imageData)) {
        if (urls.length != 1) {
          return _buildVideoPreviewPlaceholder(imageData);
        }
        mediaWidget = _buildVideoPreviewPlaceholder(imageData);
      } else {
        try {
          mediaWidget = Image.memory(
            imageData.bytes!,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, color: Colors.grey[600]),
              );
            },
          );
        } catch (e) {
          mediaWidget = Container(
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, color: Colors.grey[600]),
          );
        }
      }
    } else if (imageData != null && imageData.url != null) {
      if (VideoUtil.isVideo(imageData.url)) {
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

  Widget _buildVideoPreviewPlaceholder(dynamic videoSource) {
    if (videoSource is PlatformFile) {
      try {
        return buildVideoThumbnail(videoSource.name, videoBytes: videoSource.bytes);
      } catch (e) {
        return buildVideoThumbnail(videoSource.name);
      }
    } else if (videoSource is String) {
      return buildVideoThumbnail(videoSource);
    }
    return buildVideoThumbnail(videoSource.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    final orderedUrls = urls;

    if (orderedUrls.length == 1) {
      // 1 hình: hiển thị bình thường
      return GestureDetector(
        onTap: () => onImageTap(0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.rsr(context)),
            child: _buildImageWidget(orderedUrls[0], 0),
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
                child: _buildImageWidget(orderedUrls[0], 0),
              ),
            ),

            SizedBox(width: 4.rs(context)),

            // Ảnh mới (ảnh thứ hai)
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => onImageTap(1),
                child: _buildImageWidget(orderedUrls[1], 1),
              ),
            ),
          ],
        ),
      );
    } else {
      // 3+ hình: xuống dòng, layout grid
      return _buildClassicGrid(context, orderedUrls);
    }
  }

  Widget _buildClassicGrid(BuildContext context, List<dynamic> orderedUrls) {
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
                  child: _buildImageWidget(orderedUrls[0], 0),
                ),
              ),
              SizedBox(width: 4.rs(context)),
              Expanded(
                child: GestureDetector(
                  onTap: () => onImageTap(1),
                  child: _buildImageWidget(orderedUrls[1], 1),
                ),
              ),
            ],
          ),
        ),

        if (orderedUrls.length > 2) SizedBox(height: 4.rsh(context)),

        // Dòng thứ 2: ảnh còn lại
        AspectRatio(
          aspectRatio: 2.0,
          child: Row(children: _buildSecondRowImages(context, orderedUrls)),
        ),
      ],
    );
  }

  List<Widget> _buildSecondRowImages(
    BuildContext context,
    List<dynamic> orderedUrls,
  ) {
    List<Widget> images = [];
    final maxImagesInSecondRow = orderedUrls.length > 4
        ? 2
        : orderedUrls.length - 2;

    for (int i = 2; i < 2 + maxImagesInSecondRow; i++) {
      // khoảng cách giữa các ảnh
      if (i > 2) images.add(SizedBox(width: 4.rs(context)));

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
                  _buildImageWidget(orderedUrls[i], i),
                  Container(
                    decoration: const BoxDecoration(color: Colors.black54),
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
          ),
        );
      } else {
        images.add(
          Expanded(
            child: GestureDetector(
              onTap: () => onImageTap(i),
              child: _buildImageWidget(orderedUrls[i], i),
            ),
          ),
        );
      }
    }

    return images;
  }
}
