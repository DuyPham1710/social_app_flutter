import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:social_app_fe/core/enums/media_type.dart';

class StoryBackgroundWidget extends StatefulWidget {
  final String? mediaUrl;
  final MediaType mediaType;
  final Offset dragOffset;
  final VoidCallback? onVideoInitialized;
  final Function(int durationSeconds)? onVideoDurationChanged;
  final bool shouldPlay;

  const StoryBackgroundWidget({
    super.key,
    required this.mediaUrl,
    required this.mediaType,
    required this.dragOffset,
    this.onVideoInitialized,
    this.onVideoDurationChanged,
    this.shouldPlay = true,
  });

  @override
  State<StoryBackgroundWidget> createState() => _StoryBackgroundWidgetState();
}

class _StoryBackgroundWidgetState extends State<StoryBackgroundWidget> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.video &&
        widget.mediaUrl != null &&
        widget.mediaUrl!.isNotEmpty) {
      _initializeVideo();
    }
  }

  @override
  void didUpdateWidget(StoryBackgroundWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Nếu mediaUrl hoặc mediaType thay đổi, khởi tạo lại video
    if (widget.mediaType == MediaType.video &&
        widget.mediaUrl != null &&
        widget.mediaUrl!.isNotEmpty &&
        (oldWidget.mediaUrl != widget.mediaUrl ||
            oldWidget.mediaType != widget.mediaType)) {
      _disposeVideo().then((_) => _initializeVideo());
    }

    // Điều khiển play/pause dựa trên shouldPlay
    if (_videoController != null && _isVideoInitialized && mounted) {
      if (widget.shouldPlay) {
        if (!_videoController!.value.isPlaying) {
          _videoController!.play();
        }
      } else {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
        }
      }
    }
  }

  Future<void> _initializeVideo() async {
    if (widget.mediaUrl == null || widget.mediaUrl!.isEmpty) return;

    try {
      // Dispose controller cũ nếu có
      if (_videoController != null) {
        await _videoController!.dispose();
      }

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaUrl!),
      );

      _videoController!.addListener(_videoListener);

      await _videoController!.initialize();

      if (!mounted) {
        _videoController?.dispose();
        return;
      }

      if (_videoController!.value.hasError) {
        setState(() {
          _hasError = true;
        });
        return;
      }

      setState(() {
        _isVideoInitialized = true;
        _hasError = false;
      });

      _videoController!.setLooping(true);
      _videoController!.setVolume(1.0);

      // Lấy duration của video và gửi về parent
      final videoDuration = _videoController!.value.duration;
      if (videoDuration.inSeconds > 0 &&
          widget.onVideoDurationChanged != null) {
        widget.onVideoDurationChanged!(videoDuration.inSeconds);
      }

      // Đảm bảo video được play sau khi khởi tạo
      if (mounted) {
        await _videoController!.play();
        // Kiểm tra lại sau một khoảng thời gian ngắn để đảm bảo video đang play
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted &&
              _videoController != null &&
              _isVideoInitialized &&
              !_videoController!.value.isPlaying &&
              widget.shouldPlay) {
            _videoController!.play();
          }
        });
      }

      widget.onVideoInitialized?.call();
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isVideoInitialized = false;
        });
      }
    }
  }

  void _videoListener() {
    if (_videoController != null &&
        _videoController!.value.hasError &&
        mounted) {
      setState(() {
        _hasError = true;
      });
    }
  }

  Future<void> _disposeVideo() async {
    if (_videoController != null) {
      _videoController!.removeListener(_videoListener);
      await _videoController!.dispose();
    }
    _videoController = null;
    _isVideoInitialized = false;
    _hasError = false;
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          widget.dragOffset.dy != 0 ? 12.0 : 0.0,
        ),
        child: _buildMediaContent(),
      ),
    );
  }

  Widget _buildMediaContent() {
    if (widget.mediaUrl == null || widget.mediaUrl!.isEmpty) {
      return Container(color: Colors.grey[900]);
    }

    if (widget.mediaType == MediaType.video) {
      if (_hasError) {
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.white70, size: 48),
          ),
        );
      }

      if (!_isVideoInitialized || _videoController == null) {
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      }

      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    } else {
      // Image hoặc text
      return Container(
        color: Colors.black,
        child: Center(
          child: Image.network(
            widget.mediaUrl!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white70,
                    size: 48,
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[900],
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
