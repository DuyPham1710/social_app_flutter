import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/presentation/pages/video_player_screen.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final Function(int)? onImageTap;
  final VoidCallback? onOpenDetail;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.onImageTap,
    this.onOpenDetail,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _showControls = true;
  Timer? _controlsTimer;
  Future<Uint8List?>? _thumbnailFuture;
  static const Duration _autoHideDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = widget.thumbnailUrl != null
        ? Future.value(null)
        : generateVideoThumbnail(widget.videoUrl);
    _initializeVideo();
    _resetControlsTimer();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..addListener(_onVideoStatusChanged)
        ..setLooping(false)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
              _isPlaying = _controller.value.isPlaying;
            });
            _resetControlsTimer();
          }
        });
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  void _onVideoStatusChanged() {
    if (mounted) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(_autoHideDuration, () {
      if (!mounted) return;
      if (_showControls) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _showControlsTemporarily() {
    if (!mounted) return;
    setState(() {
      _showControls = true;
    });
    _resetControlsTimer();
  }

  void _toggleControlsVisibility() {
    if (!mounted) return;
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _resetControlsTimer();
    } else {
      _controlsTimer?.cancel();
    }
  }

  void _handleSurfaceTap() {
    if (!_isInitialized) return;

    if (_showControls) {
      widget.onOpenDetail?.call();
      return;
    }

    _showControlsTemporarily();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    _showControlsTemporarily();
  }

  void _openFullscreenVideo() {
    final currentPosition = _controller.value.position;
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoData: widget.videoUrl,
          startPosition: currentPosition,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleSurfaceTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: Colors.grey[900],
                child: widget.thumbnailUrl != null
                    ? Image.network(
                        widget.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.grey[900]);
                        },
                      )
                    : FutureBuilder<Uint8List?>(
                        future: _thumbnailFuture,
                        builder: (context, snapshot) {
                          final thumbnailBytes = snapshot.data;
                          if (thumbnailBytes == null) {
                            return Container(color: Colors.grey[900]);
                          }
                          return Image.memory(
                            thumbnailBytes,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: Colors.grey[900]);
                            },
                          );
                        },
                      ),
              ),
              if (_isInitialized) VideoPlayer(_controller),
              if (!_isInitialized)
                Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Center(
                    child: SizedBox(
                      width: 40.w,
                      height: 40.w,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.8),
                        ),
                        strokeWidth: 2.w,
                      ),
                    ),
                  ),
                ),
              if (_isInitialized)
                AnimatedOpacity(
                  opacity: _showControls ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: IgnorePointer(
                    ignoring: !_showControls,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.06),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.62),
                              ],
                              stops: const [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12.w,
                          left: 12.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 7.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.videocam_rounded,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Video',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 76.w,
                              height: 76.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.38),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 16.r,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 38.sp,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10.w,
                          right: 10.w,
                          bottom: 10.h,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _toggleControlsVisibility,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.72),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 2.8.h,
                                      thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 6.5.w,
                                      ),
                                      overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 12.w,
                                      ),
                                      activeTrackColor: AppColors.primary,
                                      inactiveTrackColor: Colors.white24,
                                      thumbColor: AppColors.primary,
                                    ),
                                    child: Slider(
                                      value: _controller.value.position.inMilliseconds
                                          .clamp(
                                            0,
                                            _controller.value.duration.inMilliseconds,
                                          )
                                          .toDouble(),
                                      max: (_controller.value.duration.inMilliseconds > 0
                                              ? _controller.value.duration.inMilliseconds
                                              : 1)
                                          .toDouble(),
                                      onChanged: (value) {
                                        _controller.seekTo(
                                          Duration(milliseconds: value.toInt()),
                                        );
                                      },
                                      onChangeEnd: (_) {
                                        _showControlsTemporarily();
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(_controller.value.position),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(_controller.value.duration),
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Fullscreen button
                        Positioned(
                          top: 12.w,
                          right: 12.w,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _openFullscreenVideo,
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(999.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 8.r,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.fullscreen_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),                        
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
