import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final dynamic videoData; // File hoặc String (URL)
  final Duration? startPosition;

  const VideoPlayerScreen({
    super.key,
    required this.videoData,
    this.startPosition,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _showControls = true;
  late Timer _hideControlsTimer;
  static const Duration _controlsAutoHideDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    // Initialize timer
    _hideControlsTimer = Timer(Duration.zero, () {});
    // Start hiding controls timer since controls are shown by default
    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer.cancel();
    _hideControlsTimer = Timer(_controlsAutoHideDuration, () {
      if (mounted && _showControls) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  Future<void> _initializeVideo() async {
    setState(() {
      _isInitialized = false;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      if (widget.videoData is File) {
        _controller = VideoPlayerController.file(widget.videoData);
      } else if (widget.videoData is String) {
        _controller = VideoPlayerController.network(widget.videoData);
      } else {
        throw Exception(context.l10n.postUnsupportedVideoType);
      }

      _controller.addListener(() {
        if (mounted) {
          if (_controller.value.hasError) {
            setState(() {
              _hasError = true;
              _errorMessage =
                  'Video player error: ${_controller.value.errorDescription}';
            });
          } else {
            // Rebuild UI to update timer and button state during playback
            setState(() {});
          }
        }
      });

      await _controller.initialize();
      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });

      // Seek to start position if provided
      if (widget.startPosition != null &&
          widget.startPosition!.inMilliseconds > 0) {
        await _controller.seekTo(widget.startPosition!);
      }

      await _controller.setVolume(1.0);
      await _controller.play();
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = context.l10n.postPlayVideoFailed(e.toString());
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _showControls = true;
    });
    _startHideControlsTimer();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    } else {
      _hideControlsTimer.cancel();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildControlsOverlay() {
    if (!_showControls) return SizedBox.shrink();

    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Close button
        Positioned(
          top: 12.h,
          left: 12.w,
          child: AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
              ),
            ),
          ),
        ),
        // Center play/pause button with animation
        Center(
          child: GestureDetector(
            onTap: _togglePlayPause,
            child: AnimatedScale(
              scale: _showControls ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _controller.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white,
                size: 64.sp,
              ),
            ),
          ),
        ),
        // Progress indicator and time info (bottom controls)
        Positioned(
          left: 10.w,
          right: 10.w,
          bottom: 10.h,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggleControls,
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
                          .clamp(0, _controller.value.duration.inMilliseconds)
                          .toDouble(),
                      max:
                          (_controller.value.duration.inMilliseconds > 0
                                  ? _controller.value.duration.inMilliseconds
                                  : 1)
                              .toDouble(),
                      onChanged: (value) {
                        _controller.seekTo(
                          Duration(milliseconds: value.toInt()),
                        );
                      },
                      onChangeEnd: (_) {
                        _startHideControlsTimer();
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _hasError
            ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 64.sp,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: _initializeVideo,
                        child: Text(context.l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Center(
                      child: _isInitialized
                          ? GestureDetector(
                              onTap: _toggleControls,
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: Stack(
                                  children: [
                                    VideoPlayer(_controller),
                                    _buildControlsOverlay(),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  context.l10n.postLoadingVideo,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
