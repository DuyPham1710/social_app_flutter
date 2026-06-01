import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  static final Map<String, String> _thumbnailCache = {};
  String? _thumbnailPath;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(VideoThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    final url = widget.videoUrl;

    // 1. Kiểm tra nếu là Cloudinary URL thì xử lý đồng bộ
    if (url.contains('cloudinary.com')) {
      if (mounted) {
        setState(() {
          _thumbnailPath = _getCloudinaryThumbnail(url);
          _isLoading = false;
          _hasError = false;
        });
      }
      return;
    }

    // 2. Kiểm tra cache
    if (_thumbnailCache.containsKey(url)) {
      if (mounted) {
        setState(() {
          _thumbnailPath = _thumbnailCache[url];
          _isLoading = false;
          _hasError = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: url,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 250,
        quality: 75,
      );

      if (thumbnail != null) {
        _thumbnailCache[url] = thumbnail;
        if (mounted) {
          setState(() {
            _thumbnailPath = thumbnail;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  String _getCloudinaryThumbnail(String url) {
    String thumbnail = url;
    final videoExtensions = ['.mp4', '.mov', '.mkv', '.webm', '.avi', '.3gp', '.flv'];
    for (final ext in videoExtensions) {
      if (thumbnail.toLowerCase().endsWith(ext)) {
        thumbnail = thumbnail.substring(0, thumbnail.length - ext.length) + '.jpg';
        break;
      }
    }
    if (thumbnail.contains('/video/upload/')) {
      thumbnail = thumbnail.replaceFirst('/video/upload/', '/video/upload/w_200,h_300,c_fill,so_0/');
    }
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    final isCloudinary = widget.videoUrl.contains('cloudinary.com');

    Widget child;
    if (_hasError) {
      child = Container(
        color: AppColors.secondBackground,
        child: const Center(
          child: Icon(
            Icons.videocam_off_outlined,
            color: Colors.white54,
            size: 24,
          ),
        ),
      );
    } else if (_isLoading || _thumbnailPath == null) {
      child = Container(
        color: AppColors.secondBackground,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white30),
            ),
          ),
        ),
      );
    } else {
      if (isCloudinary) {
        child = Image.network(
          _thumbnailPath!,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.secondBackground,
              child: const Center(
                child: Icon(
                  Icons.videocam_outlined,
                  color: Colors.white54,
                  size: 24,
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(color: AppColors.secondBackground);
          },
        );
      } else {
        child = Image.file(
          File(_thumbnailPath!),
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.secondBackground,
              child: const Center(
                child: Icon(
                  Icons.videocam_outlined,
                  color: Colors.white54,
                  size: 24,
                ),
              ),
            );
          },
        );
      }
    }

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: SizedBox(width: widget.width, height: widget.height, child: child),
    );
  }
}
