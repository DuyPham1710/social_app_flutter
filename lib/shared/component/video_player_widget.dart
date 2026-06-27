import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/post/presentation/pages/video_player_screen.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _showControls = true;
  Timer? _controlsTimer;
  Future<Uint8List?>? _thumbnailFuture;
  static const Duration _autoHideDuration = Duration(seconds: 3);

  bool _hasError = false;
  bool _isMuted = true; // Auto-play starts muted
  bool _isVisibleInViewport = false;
  bool _userPaused = false; // Track if user manually paused

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
        ..setLooping(true)
        ..initialize()
            .then((_) {
              if (mounted) {
                // Start muted for auto-play
                _controller?.setVolume(0.0);
                setState(() {
                  _isInitialized = true;
                  _isPlaying = _controller?.value.isPlaying ?? false;
                });
                _resetControlsTimer();
                // If already visible when initialized, start playing
                if (_isVisibleInViewport) {
                  _controller?.play();
                  setState(() {
                    _isPlaying = true;
                  });
                }
              }
            })
            .catchError((e) {
              debugPrint('Error initializing video: $e');
              if (mounted) {
                setState(() {
                  _hasError = true;
                });
              }
            });
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _onVideoStatusChanged() {
    if (mounted) {
      setState(() {
        _isPlaying = _controller?.value.isPlaying ?? false;
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
      _controller?.pause();
      _userPaused = true;
    } else {
      _controller?.play();
      _userPaused = false;
    }
    _showControlsTemporarily();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller?.setVolume(_isMuted ? 0.0 : 1.0);
    });
    _showControlsTemporarily();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted || !_isInitialized) return;

    final visibleFraction = info.visibleFraction;
    final wasVisible = _isVisibleInViewport;
    _isVisibleInViewport = visibleFraction >= 0.5;

    if (_isVisibleInViewport && !wasVisible) {
      // Video scrolled into view - auto-play if user didn't manually pause
      if (!_userPaused) {
        _controller?.play();
        setState(() {
          _isPlaying = true;
        });
      }
    } else if (!_isVisibleInViewport && wasVisible) {
      // Video scrolled out of view - auto-pause
      if (_controller?.value.isPlaying == true) {
        _controller?.pause();
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  void _openFullscreenVideo() {
    final currentPosition = _controller?.value.position;
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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video-player-${widget.videoUrl.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.rsr(context)),
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
                if (_isInitialized && _controller != null)
                  VideoPlayer(_controller!),
                if (_isInitialized)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _handleSurfaceTap,
                      child: const SizedBox.expand(),
                    ),
                  ),
                if (!_isInitialized)
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Center(
                      child: _hasError
                          ? Icon(
                              Icons.error_outline_rounded,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 40.rsp(context),
                            )
                          : SizedBox(
                              width: 40.rs(context),
                              height: 40.rs(context),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withValues(alpha: 0.8),
                                ),
                                strokeWidth: 2.rs(context),
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
                            top: 12.rs(context),
                            left: 12.rs(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.rs(context),
                                vertical: 7.rsh(context),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(
                                  999.rsr(context),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.videocam_rounded,
                                    color: Colors.white,
                                    size: 14.rsp(context),
                                  ),
                                  SizedBox(width: 6.rs(context)),
                                  Text(
                                    'Video',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.rsp(context),
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
                                width: 76.rs(context),
                                height: 76.rs(context),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withValues(alpha: 0.38),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 16.rsr(context),
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 38.rsp(context),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10.rs(context),
                            right: 10.rs(context),
                            bottom: 10.rsh(context),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _toggleControlsVisibility,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  12.rs(context),
                                  10.rsh(context),
                                  12.rs(context),
                                  10.rsh(context),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.72),
                                  borderRadius: BorderRadius.circular(
                                    16.rsr(context),
                                  ),
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
                                        trackHeight: 2.8.rsh(context),
                                        thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 6.5.rs(context),
                                        ),
                                        overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 12.rs(context),
                                        ),
                                        activeTrackColor: AppColors.primary,
                                        inactiveTrackColor: Colors.white24,
                                        thumbColor: AppColors.primary,
                                      ),
                                      child: Slider(
                                        value:
                                            (_controller
                                                        ?.value
                                                        .position
                                                        .inMilliseconds ??
                                                    0)
                                                .clamp(
                                                  0,
                                                  _controller
                                                          ?.value
                                                          .duration
                                                          .inMilliseconds ??
                                                      1,
                                                )
                                                .toDouble(),
                                        max:
                                            ((_controller
                                                                ?.value
                                                                .duration
                                                                .inMilliseconds ??
                                                            0) >
                                                        0
                                                    ? _controller!
                                                          .value
                                                          .duration
                                                          .inMilliseconds
                                                    : 1)
                                                .toDouble(),
                                        onChanged: (value) {
                                          _controller?.seekTo(
                                            Duration(
                                              milliseconds: value.toInt(),
                                            ),
                                          );
                                        },
                                        onChangeEnd: (_) {
                                          _showControlsTemporarily();
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDuration(
                                            _controller?.value.position ??
                                                Duration.zero,
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.rsp(context),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          _formatDuration(
                                            _controller?.value.duration ??
                                                Duration.zero,
                                          ),
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11.rsp(context),
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
                            top: 12.rs(context),
                            right: 12.rs(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Mute/Unmute button
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _toggleMute,
                                  child: Container(
                                    padding: EdgeInsets.all(10.rs(context)),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        999.rsr(context),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 8.rsr(context),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _isMuted
                                          ? Icons.volume_off_rounded
                                          : Icons.volume_up_rounded,
                                      color: Colors.white,
                                      size: 20.rsp(context),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.rs(context)),
                                // Fullscreen button
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _openFullscreenVideo,
                                  child: Container(
                                    padding: EdgeInsets.all(10.rs(context)),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        999.rsr(context),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 8.rsr(context),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.fullscreen_rounded,
                                      color: Colors.white,
                                      size: 20.rsp(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Mute indicator when controls are hidden
                if (!_showControls)
                  Positioned(
                    bottom: 12.rsh(context),
                    right: 12.rs(context),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _toggleMute,
                      child: AnimatedOpacity(
                        opacity: 0.85,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: EdgeInsets.all(8.rs(context)),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isMuted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 16.rsp(context),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
