import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AudioMessageBubble extends StatefulWidget {
  final bool fromMe;
  final AttachmentEntity attachment;

  const AudioMessageBubble({
    super.key,
    required this.fromMe,
    required this.attachment,
  });

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  static _AudioMessageBubbleState? _activeBubble;

  late final AudioPlayer _audioPlayer;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<void>? _completeSubscription;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      PlayerState state,
    ) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((
      Duration position,
    ) {
      if (!mounted || _isDragging) return;
      setState(() {
        _currentPosition = position;
      });
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((
      Duration duration,
    ) {
      if (!mounted) return;
      setState(() {
        _totalDuration = duration;
      });
    });

    _completeSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });

      if (_activeBubble == this) {
        _activeBubble = null;
      }
    });
  }

  @override
  void dispose() {
    if (_activeBubble == this) {
      _activeBubble = null;
    }

    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _completeSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _stopPlaybackAndReset() async {
    await _audioPlayer.stop();
    if (!mounted) return;

    setState(() {
      _isPlaying = false;
      _currentPosition = Duration.zero;
    });
  }

  Future<void> _onAudioTap() async {
    final audioUrl = widget.attachment.url;
    if (audioUrl.isEmpty) return;

    try {
      // Nếu đang phát thì pause, không reset về 0
      if (_isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      // Chỉ cho phép một audio phát tại một thời điểm
      if (_activeBubble != null && _activeBubble != this) {
        await _activeBubble!._stopPlaybackAndReset();
      }

      // Nếu chưa từng phát hoặc đã phát xong, phát từ đầu
      if (_currentPosition == Duration.zero || !_isPlaying) {
        await _audioPlayer.play(UrlSource(audioUrl));
      } else {
        // Resume từ vị trí hiện tại
        await _audioPlayer.resume();
      }

      _activeBubble = this;
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });

      if (_activeBubble == this) {
        _activeBubble = null;
      }
    }
  }

  Future<void> _onSeekUpdate(double dx, double maxWidth) async {
    if (!mounted) return;
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });

    _isDragging = true;
    final progress = (dx / maxWidth).clamp(0.0, 1.0);

    // Sử dụng totalDuration từ audio hoặc duration từ attachment
    final duration = _totalDuration != Duration.zero
        ? _totalDuration
        : Duration(seconds: widget.attachment.duration ?? 0);

    final soughtMilliseconds = (progress * duration.inMilliseconds).floor();

    setState(() {
      _currentPosition = Duration(milliseconds: soughtMilliseconds);
    });
  }

  Future<void> _onSeekEnd() async {
    if (!mounted || !_isDragging) return;

    await _audioPlayer.seek(_currentPosition);
    setState(() {
      _isDragging = false;
      _isPlaying = true;
    });
    await _audioPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    final waveformBars = _buildWaveformBars(widget.attachment.waveform);

    // Tính toán progress
    final duration = _totalDuration != Duration.zero
        ? _totalDuration
        : Duration(seconds: widget.attachment.duration ?? 0);

    final progress = duration.inMilliseconds > 0
        ? _currentPosition.inMilliseconds / duration.inMilliseconds
        : 0.0;

    final playedBars = (progress * waveformBars.length).floor();

    final shownSeconds = _isPlaying || _currentPosition != Duration.zero
        ? _currentPosition.inSeconds
        : widget.attachment.duration ?? 0;
    final durationText = _formatAudioDuration(shownSeconds);

    return Container(
      constraints: BoxConstraints(maxWidth: 0.7.sw),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: widget.fromMe
            ? AppColors.primary
            : AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: Radius.circular(widget.fromMe ? 16.r : 0),
          bottomRight: Radius.circular(widget.fromMe ? 0 : 16.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _onAudioTap,
            child: Icon(
              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: widget.fromMe ? Colors.white : AppColors.textPrimary,
              size: 32.sp,
            ),
          ),
          SizedBox(width: 8.w),

          // Waveform với seek functionality
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) async {
                    await _onSeekUpdate(
                      details.localPosition.dx,
                      constraints.maxWidth,
                    );
                    await _onSeekEnd();
                  },
                  onHorizontalDragStart: (details) {
                    _onSeekUpdate(
                      details.localPosition.dx,
                      constraints.maxWidth,
                    );
                  },
                  onHorizontalDragUpdate: (details) {
                    _onSeekUpdate(
                      details.localPosition.dx,
                      constraints.maxWidth,
                    );
                  },
                  onHorizontalDragEnd: (details) {
                    _onSeekEnd();
                  },
                  onHorizontalDragCancel: () => _onSeekEnd(),
                  child: Container(
                    height: 24.h,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(waveformBars.length, (index) {
                        // Màu bar thay đổi dựa trên progress
                        final barColor = index < playedBars
                            ? (widget.fromMe ? Colors.white : AppColors.primary)
                            : (widget.fromMe
                                  ? Colors.white.withOpacity(0.5)
                                  : AppColors.primary.withOpacity(0.5));

                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                          width: 3.w,
                          height: waveformBars[index].h,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(width: 12.w),
          Text(
            durationText,
            style: TextStyle(
              color: widget.fromMe ? Colors.white : AppColors.textPrimary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAudioDuration(int? seconds) {
    if (seconds == null || seconds < 0) return '0:00';

    final minutes = seconds ~/ 60;
    final remainSeconds = seconds % 60;
    return '$minutes:${remainSeconds.toString().padLeft(2, '0')}';
  }

  List<double> _buildWaveformBars(List<double>? waveform) {
    if (waveform == null || waveform.isEmpty) {
      return const [
        8.0,
        14.0,
        20.0,
        10.0,
        24.0,
        12.0,
        18.0,
        8.0,
        22.0,
        14.0,
        10.0,
        16.0,
        8.0,
        18.0,
        12.0,
      ];
    }

    int targetBars = int.parse(dotenv.env['TARGET_BARS'] ?? '15');
    final bars = <double>[];
    final step = waveform.length / targetBars;

    for (int i = 0; i < targetBars; i++) {
      int start = (i * step).floor();
      int end = ((i + 1) * step).floor();
      if (end > waveform.length) end = waveform.length;
      if (start >= end) start = end - 1;
      if (start < 0) start = 0;

      double maxValue = 0.0;
      for (int j = start; j < end; j++) {
        final normalized = _normalizeWaveformValue(waveform[j]);
        if (normalized > maxValue) {
          maxValue = normalized;
        }
      }

      // UI bar height: 4..22 (tương ứng với normalized 0..1)
      bars.add(4.0 + (maxValue * 18.0));
    }

    return bars;
  }

  double _normalizeWaveformValue(double value) {
    if (value.isNaN || value.isInfinite) return 0.0;

    if (value >= 0.0 && value <= 1.0) {
      return value;
    }

    // Backward compatibility for old 4..28 waveform format.
    if (value >= 4.0 && value <= 28.0) {
      return ((value - 4.0) / 24.0).clamp(0.0, 1.0).toDouble();
    }

    return value < 0 ? 0.0 : 1.0;
  }
}
