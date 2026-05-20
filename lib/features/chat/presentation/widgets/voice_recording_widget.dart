import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/chat/presentation/helper/chat_helper.dart';
import 'package:social_app_fe/features/chat/presentation/widgets/voice_effect_bottom_sheet.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceRecordingWidget extends StatefulWidget {
  final Function(
    String filePath, {
    required int duration,
    required List<double> waveform,
  })
  onSend;

  final VoidCallback onCancel;

  const VoiceRecordingWidget({
    super.key,
    required this.onSend,
    required this.onCancel,
  });

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget>
    with SingleTickerProviderStateMixin {
  late final AudioRecorder _audioRecorder;
  bool _isRecording = false;
  int _recordDuration = 0;
  Timer? _timer;
  String? _filePath;
  String? _originalFilePath;

  // Waveform
  final List<double> _waveformHeights = List.generate(100, (index) => 4.0);
  final List<double> _allAmplitudes = [];
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  // Audio Playback
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _hasRecorded = false;
  Duration _playbackPosition = Duration.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();

    _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer!.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playbackPosition = Duration.zero;
        });
      }
    });

    _audioPlayer!.onPositionChanged.listen((Duration p) {
      if (mounted && !_isDragging) {
        setState(() {
          _playbackPosition = p;
        });
      }
    });

    _startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amplitudeSubscription?.cancel();
    _audioRecorder.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        if (mounted) {
          setState(() {
            _isRecording = true;
            _recordDuration = 0;
            _filePath = filePath;
            _originalFilePath = filePath;
            _allAmplitudes.clear();
          });

          _startTimer();

          _amplitudeSubscription = _audioRecorder
              .onAmplitudeChanged(const Duration(milliseconds: 50))
              .listen((Amplitude amp) {
                if (mounted && _isRecording) {
                  _addAmplitude(amp.current);
                }
              });
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context, 'Không có quyền truy cập microphone');

          widget.onCancel();
        }
      }
    } catch (e) {
      print('Error starting recording: $e');
      if (mounted) {
        showErrorSnackBar(context, 'Lỗi khi bắt đầu ghi âm');
        widget.onCancel();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() => _recordDuration++);
      }
    });
  }

  void _addAmplitude(double dB) {
    // Ngưỡng im lặng khoảng -45dB (nhiễu nền), ngưỡng nói to là -10dB.
    // Khi chưa nói (thường khoảng không này nằm dưới -35dB), sóng sẽ bị ép về 0 (nhỏ xíu).
    const double minDb = -30.0;
    const double maxDb = -10.0;

    double factor = (dB - minDb) / (maxDb - minDb);
    factor = factor.clamp(0.0, 1.0);

    // Dùng hàm mũ nhỏ để làm mượt đường cong tăng trưởng của âm độ
    factor = pow(factor, 1.2).toDouble();

    // Chiều cao mục tiêu
    double targetHeight = factor * 24.0 + 4.0;

    // Giảm nhảy giật cục bằng cách mix với chiều cao của bar gần nhất trước đó
    double previousHeight = _waveformHeights.last;
    double newHeight = previousHeight + (targetHeight - previousHeight) * 0.7;

    setState(() {
      _waveformHeights.removeAt(0);
      _waveformHeights.add(newHeight);
      _allAmplitudes.add(newHeight);
    });
  }

  Future<void> _finishRecording() async {
    if (!_isRecording) return;

    _timer?.cancel();
    _amplitudeSubscription?.cancel();

    if (mounted) {
      setState(() => _isRecording = false);
    }

    final path = await _audioRecorder.stop();
    print('Recording stopped, file saved at: $path');

    if (path != null && mounted) {
      setState(() {
        _filePath = path;
        _originalFilePath ??= path;
        _hasRecorded = true;
      });
    } else {
      if (mounted) widget.onCancel();
    }
  }

  Future<void> _trashRecording() async {
    _timer?.cancel();
    _amplitudeSubscription?.cancel();
    _audioPlayer?.stop();

    try {
      if (_isRecording) {
        await _audioRecorder.stop();
      }
    } catch (e) {
      print('Error stopping recorder when trashing: $e');
    }

    if (mounted) widget.onCancel();
  }

  void _onSeekUpdate(double dx, double maxWidth) {
    if (!_hasRecorded || _recordDuration == 0) return;
    _isDragging = true;
    double progress = (dx / maxWidth).clamp(0.0, 1.0);
    int soughtMilliseconds = (progress * _recordDuration * 1000).floor();
    setState(() {
      _playbackPosition = Duration(milliseconds: soughtMilliseconds);
    });
  }

  void _onSeekEnd() {
    if (!_hasRecorded || _recordDuration == 0 || !_isDragging) return;
    _audioPlayer?.seek(_playbackPosition);
    setState(() {
      _isDragging = false;
    });
  }

  Future<void> _sendRecording() async {
    if (_isRecording) {
      _timer?.cancel();
      _amplitudeSubscription?.cancel();
      try {
        final path = await _audioRecorder.stop();
        if (path != null) {
          _filePath = path;
          _originalFilePath ??= path;
        }
      } catch (e) {
        print('Error stopping recorder on send: $e');
      }
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }
    }

    if (_filePath != null) {
      final waveform40Bars = ChatHelper.compressWaveformTo40Bars(
        _allAmplitudes,
      );

      widget.onSend(
        _filePath!,
        duration: _recordDuration,
        waveform: waveform40Bars,
      );
    } else {
      widget.onCancel();
    }
  }

  Future<void> _playPauseAudio() async {
    if (_filePath == null) return;

    if (_isPlaying) {
      await _audioPlayer?.pause();
    } else {
      await _audioPlayer?.play(DeviceFileSource(_filePath!));
    }
  }

  String _formatDuration(int duration) {
    String minutes = (duration ~/ 60).toString().padLeft(2, '0');
    String seconds = (duration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24.r),
            ),

            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_isRecording) {
                      _finishRecording();
                    } else {
                      _playPauseAudio();
                    }
                  },
                  child: Icon(
                    _isRecording
                        ? CupertinoIcons.stop_fill
                        : (_isPlaying
                              ? CupertinoIcons.pause_fill
                              : CupertinoIcons.play_arrow_solid),
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final barWidthWithMargin = 5.w;
                      final int barCount =
                          (constraints.maxWidth / barWidthWithMargin)
                              .floor()
                              .clamp(1, 100);

                      return GestureDetector(
                        onTapDown: (details) {
                          _onSeekUpdate(
                            details.localPosition.dx,
                            constraints.maxWidth,
                          );
                          _onSeekEnd();
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
                          color: Colors
                              .transparent, // Transparent catch drag events
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              barCount,
                              (index) => _buildWaveformBar(index, barCount),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(width: 12.w),

                Text(
                  _formatDuration(
                    (_isRecording ||
                            (!_isPlaying && _playbackPosition == Duration.zero))
                        ? _recordDuration
                        : _playbackPosition.inSeconds,
                  ),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _trashRecording,
                icon: Icon(
                  CupertinoIcons.trash_fill,
                  color: AppColors.textSecondary,
                  size: 24.sp,
                ),
              ),

              GestureDetector(
                onTap: () async {
                  await _finishRecording();

                  if (mounted && _filePath != null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => VoiceEffectBottomSheet(
                        filePath: _originalFilePath ?? _filePath!,
                        onVoiceChanged: (newFilePath) {
                          setState(() {
                            _filePath = newFilePath;
                            // Reset player để phát file mới
                            _isPlaying = false;
                            _playbackPosition = Duration.zero;
                          });
                        },
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: AppColors.textPrimary,
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Chỉnh sửa',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: _sendRecording,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),

                  child: Center(
                    child: Icon(
                      CupertinoIcons.paperplane_fill,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformBar(int index, int barCount) {
    double height = 4.0;
    Color barColor = AppColors.primary.withOpacity(0.5);

    if (_isRecording) {
      int targetIndex = _waveformHeights.length - barCount + index;
      if (targetIndex >= 0 && targetIndex < _waveformHeights.length) {
        height = _waveformHeights[targetIndex];
      }
      barColor = AppColors.primary;
    } else if (_hasRecorded) {
      if (_allAmplitudes.isNotEmpty) {
        double step = _allAmplitudes.length / barCount;
        int start = (index * step).floor();
        int end = ((index + 1) * step).floor();
        if (end > _allAmplitudes.length) end = _allAmplitudes.length;
        if (start >= end) start = end - 1;
        if (start < 0) start = 0;

        double maxH = 4.0;
        for (int j = start; j < end; j++) {
          if (_allAmplitudes[j] > maxH) maxH = _allAmplitudes[j];
        }
        height = maxH;
      }

      // Xử lý phủ màu bar đã play qua
      double progress = 0;
      if (_recordDuration > 0) {
        progress =
            _playbackPosition.inMilliseconds / (_recordDuration * 1000.0);
      }
      int playedBars = (progress * barCount).floor();
      barColor = index < playedBars
          ? AppColors.primary
          : AppColors.primary.withOpacity(0.5);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      width: 3.w,
      height: height,
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}
