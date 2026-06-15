import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/utils/video_util.dart';
import 'package:social_app_fe/shared/component/video_player_widget.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';

class LayoutPostColumn extends StatelessWidget {
  final List<dynamic> urls;
  final Function(int) onImageTap;

  const LayoutPostColumn({
    super.key,
    required this.urls,
    required this.onImageTap,
  });

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
        mediaWidget = VideoPlayerWidget(
          videoUrl: imageData.path,
          onOpenDetail: () => onImageTap(index),
        );
      } else {
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
    final maxImages = orderedUrls.length > 4 ? 4 : orderedUrls.length;

    if (orderedUrls.length == 1) {
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
    }

    return SizedBox(
      height: 280.rsh(context),
      child: Row(
        children: [
          for (int i = 0; i < maxImages; i++) ...[
            if (i > 0) SizedBox(width: 4.rs(context)),
            Expanded(child: _buildColumnImage(context, i, orderedUrls)),
          ],
        ],
      ),
    );
  }

  Widget _buildColumnImage(BuildContext context, int index, List<dynamic> orderedUrls) {
    double topPadding = 0;
    double bottomPadding = 0;

    if (orderedUrls.length >= 3) {
      switch (index % 4) {
        case 0:
          topPadding = 0;
          bottomPadding = 30.rsh(context);
        case 1:
          topPadding = 10.rsh(context);
          bottomPadding = 0;
        case 2:
          topPadding = 0;
          bottomPadding = 30.rsh(context);
        case 3:
          topPadding = 10.rsh(context);
          bottomPadding = 0;
      }
    }

    Widget imageWidget = GestureDetector(
      onTap: () => onImageTap(index),
      child: SizedBox(
        height: 250.rsh(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.rsr(context)),
          child: _buildImageWidget(orderedUrls[index], index),
        ),
      ),
    );

    if (index == 3 && orderedUrls.length > 4) {
      final remaining = orderedUrls.length - 4;
      imageWidget = GestureDetector(
        onTap: () => onImageTap(index),
        child: SizedBox(
          height: 250.rsh(context),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.rsr(context)),
                child: _buildImageWidget(orderedUrls[index], index),
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
                    fontSize: 28.rsp(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: imageWidget,
    );
  }
}
