import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:social_app_fe/core/utils/web_video_url_helper.dart';

class WebVideoPreview extends StatefulWidget {
  final String videoUrl;
  final Uint8List? videoBytes;
  final BoxFit fit;

  const WebVideoPreview({
    required this.videoUrl,
    this.videoBytes,
    required this.fit,
  });

  @override
  State<WebVideoPreview> createState() => _WebVideoPreviewState();
}

class _WebVideoPreviewState extends State<WebVideoPreview> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  String? _blobUrl;

  @override
  void initState() {
    super.initState();
    String targetUrl = widget.videoUrl;

    if (widget.videoBytes != null) {
      try {
        _blobUrl = createObjectUrlFromBytes(widget.videoBytes!);
        targetUrl = _blobUrl!;
      } catch (e) {
        // Fallback
      }
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(targetUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          // To make it look like a thumbnail, seek to beginning
          _controller?.seekTo(Duration.zero);
        }
      }).catchError((e) {
        // print('Error loading web video preview: $e');
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    if (_blobUrl != null) {
      revokeObjectUrl(_blobUrl!);
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: widget.fit,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }
}
