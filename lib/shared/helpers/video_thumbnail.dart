import 'dart:typed_data';
import 'dart:collection';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/shared/helpers/web_video_preview.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

const int _maxThumbnailCacheSize = 10;
final LinkedHashMap<String, Future<Uint8List?>> _thumbnailFutureCache =
    LinkedHashMap<String, Future<Uint8List?>>();

Future<Uint8List?> getCachedVideoThumbnail(String videoUrl) {
  // LRU: nếu đã có thì move xuống cuối (mới dùng gần nhất)
  if (_thumbnailFutureCache.containsKey(videoUrl)) {
    final existing = _thumbnailFutureCache.remove(videoUrl)!;
    _thumbnailFutureCache[videoUrl] = existing;
    return existing;
  }

  final created = generateVideoThumbnail(videoUrl);
  _thumbnailFutureCache[videoUrl] = created;

  while (_thumbnailFutureCache.length > _maxThumbnailCacheSize) {
    _thumbnailFutureCache.remove(_thumbnailFutureCache.keys.first);
  }

  return created;
}

void clearVideoThumbnailCache({String? videoUrl}) {
  if (videoUrl != null) {
    _thumbnailFutureCache.remove(videoUrl);
    return;
  }
  _thumbnailFutureCache.clear();
}

Future<Uint8List?> generateVideoThumbnail(String videoUrl) async {
  try {
    return await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 720,
      quality: 75,
    );
  } catch (_) {
    return null;
  }
}

Widget buildVideoThumbnail(
  String videoUrl, {
  Uint8List? videoBytes,
  BoxFit fit = BoxFit.cover,
  BorderRadius? borderRadius,
  double? height,
}) {
  return Builder(
    builder: (context) {
      final previewHeight = height ?? 300.rsh(context);

      return FutureBuilder<Uint8List?>(
        future: kIsWeb ? Future.value(null) : getCachedVideoThumbnail(videoUrl),
        builder: (context, snapshot) {
          final thumbnailBytes = snapshot.data;

          final preview = kIsWeb
              ? WebVideoPreview(
                  videoUrl: videoUrl,
                  videoBytes: videoBytes,
                  fit: fit,
                )
              : (thumbnailBytes != null
                    ? Image.memory(
                        thumbnailBytes,
                        fit: fit,
                        width: double.infinity,
                        height: double.infinity,
                        gaplessPlayback: true,
                      )
                    : Container(
                        color: Colors.black,
                        child: Center(
                          child: Icon(
                            Icons.videocam_rounded,
                            color: Colors.white54,
                            size: 48.rsp(context),
                          ),
                        ),
                      ));

          final thumbnail = SizedBox(
            height: previewHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                preview,
                Container(
                  color: Colors.black.withValues(alpha: 0.18),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(14.rs(context)),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_circle_filled_rounded,
                        color: Colors.white,
                        size: 52.rsp(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );

          if (borderRadius != null) {
            return ClipRRect(borderRadius: borderRadius, child: thumbnail);
          }

          return thumbnail;
        },
      );
    },
  );
}
