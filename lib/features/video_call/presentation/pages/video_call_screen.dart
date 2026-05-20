import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/services/call_sound_service.dart';
import 'package:social_app_fe/features/video_call/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/video_call/presentation/pages/call_feedback_screen.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelId;
  final String token;
  final String appId;
  final String callId;
  final String userId;
  final bool isVideo;
  final bool isCaller;
  final String? callerName;
  final String? callerAvatar;
  final String? receiverName; // Người nhận (dành cho caller)
  final String? receiverAvatar; // Avatar người nhận (dành cho caller)

  const VideoCallScreen({
    super.key,
    required this.channelId,
    required this.token,
    required this.appId,
    required this.callId,
    required this.userId,
    this.isVideo = true,
    this.isCaller = true,
    this.callerName,
    this.callerAvatar,
    this.receiverName,
    this.receiverAvatar,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _isRemoteCameraOff = false; // Track trạng thái camera remote user
  bool _isFrontCamera = true;
  Timer? _callTimer;
  Timer? _callTimeoutTimer;
  int _callDuration = 0;
  late bool _isSpeakerOn; // true = loa ngoài, false = loa trong
  // late VideoCallBloc _videoCallBloc;
  bool _isConnecting = true;
  bool _hasRemoteUserJoined = false; // Track if remote user has EVER joined
  final CallSoundService _soundService = CallSoundService();

  static const int _callTimeoutSeconds = 45;

  @override
  void initState() {
    super.initState();

    // _videoCallBloc = s1<VideoCallBloc>();

    // Video call: loa ngoài, Audio call: loa trong (Khi bắt đầu)
    _isSpeakerOn = widget.isVideo;

    _initAgora();
    _startCallTimer();

    // Nếu là caller, bắt đầu timer và play ringtone
    if (widget.isCaller) {
      _startCallTimeoutTimer();
      _soundService.playRingtone(); // Play "tút tút" sound for caller
    }
  }

  Future<void> _initAgora() async {
    try {
      _engine = createAgoraRtcEngine();

      await _engine.initialize(
        RtcEngineContext(
          appId: widget.appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // Register event handlers
      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
            if (mounted) {
              setState(() {
                _localUserJoined = true;
                _isConnecting = false;
              });
              // Set speaker mode after successfully joining channel
              try {
                await _engine.setEnableSpeakerphone(_isSpeakerOn);
              } catch (e) {
                debugPrint('[VideoCall] Failed to set speaker mode: $e');
              }
            }
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            if (mounted) {
              setState(() {
                _remoteUid = remoteUid;
                _isConnecting = false;
                _hasRemoteUserJoined = true; // Mark that remote user has joined
              });
            }
            _callTimeoutTimer?.cancel();
            _soundService.stop(); // Stop ringtone when remote user joins
          },
          onUserOffline:
              (
                RtcConnection connection,
                int remoteUid,
                UserOfflineReasonType reason,
              ) {
                if (mounted) {
                  setState(() {
                    _remoteUid = null;
                  });
                  _endCall();
                }
              },
          onRemoteVideoStateChanged:
              (
                RtcConnection connection,
                int remoteUid,
                RemoteVideoState state,
                RemoteVideoStateReason reason,
                int elapsed,
              ) {
                // Xử lý khi remote user tắt/bật camera
                if (mounted) {
                  setState(() {
                    _isRemoteCameraOff =
                        (state == RemoteVideoState.remoteVideoStateStopped ||
                        state == RemoteVideoState.remoteVideoStateFrozen);
                  });
                }
              },
        ),
      );

      if (widget.isVideo) {
        await _engine.enableVideo();
        await _engine.startPreview();
      } else {
        await _engine.disableVideo();
      }

      await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelId,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
    } catch (e) {
      _showError('Failed to initialize call: $e');
    }
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDuration++;
        });
      }
    });
  }

  void _startCallTimeoutTimer() {
    _callTimeoutTimer = Timer(const Duration(seconds: _callTimeoutSeconds), () {
      if (mounted && _remoteUid == null && !_hasRemoteUserJoined) {
        _showError('Không có phản hồi');
        _endCall();
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _toggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
    });
    await _engine.muteLocalAudioStream(_isMuted);
  }

  Future<void> _toggleCamera() async {
    if (!widget.isVideo) return;

    setState(() {
      _isCameraOff = !_isCameraOff;
    });
    await _engine.muteLocalVideoStream(_isCameraOff);
  }

  Future<void> _switchCamera() async {
    if (!widget.isVideo) return;

    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
    await _engine.switchCamera();
  }

  void _toggleSpeaker() async {
    // Toggle between speaker (loa ngoài) and earpiece (loa trong)
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });

    // Switch between speakerphone and earpiece in Agora
    await _engine.setEnableSpeakerphone(_isSpeakerOn);

    debugPrint(
      '[VideoCall] Speaker mode: ${_isSpeakerOn ? "Loa ngoài" : "Loa trong (earpiece)"}',
    );
  }

  Future<void> _endCall() async {
    try {
      // Stop sound when ending call
      await _soundService.stop();

      String callStatus;
      if (!_hasRemoteUserJoined && widget.isCaller) {
        // Caller ending before receiver EVER joined = missed
        callStatus = 'missed';
      } else {
        // Remote user joined at some point = completed
        callStatus = 'completed';
      }

      context.read<VideoCallBloc>().add(
        EndCall(
          userId: widget.userId,
          callId: widget.callId,
          duration: _callDuration,
          callStatus: callStatus, // Pass determined status
        ),
      );
      await _engine.leaveChannel();

      if (mounted) {
        // Only show feedback screen for completed calls
        // For missed calls, just pop back to chat
        if (callStatus == 'completed') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CallFeedbackScreen(
                callerName: widget.isCaller
                    ? (widget.receiverName ?? 'Unknown')
                    : (widget.callerName ?? 'Unknown'),
                callerAvatar: widget.isCaller
                    ? widget.receiverAvatar
                    : widget.callerAvatar,
                callDuration: _callDuration,
                wasRejected: false,
                onClose: () {
                  // Pop feedback screen and return to chat
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        } else {
          // Missed call - just pop back
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      // Ignore errors during cleanup
    }
  }

  void _showError(String message) {
    if (mounted) {
      showErrorSnackBar(context, message);
    }
  }

  bool _isDisposing = false;

  @override
  void dispose() {
    if (_isDisposing) {
      super.dispose();
      return;
    }

    _isDisposing = true;
    _callTimer?.cancel();
    _callTimeoutTimer?.cancel();
    _soundService.stop(); // Stop sound when disposing

    try {
      _engine.leaveChannel();
      _engine.release();
    } catch (e) {
      // Ignore cleanup errors
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoCallBloc, VideoCallState>(
      //  bloc: _videoCallBloc,
      listener: (context, state) {
        // Khi bị reject, hiện feedback screen
        if (state.status == VideoCallStatus.callRejected) {
          if (mounted) {
            _engine.leaveChannel();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CallFeedbackScreen(
                  callerName: widget.isCaller
                      ? (widget.receiverName ?? 'Unknown')
                      : (widget.callerName ?? 'Unknown'),
                  callerAvatar: widget.isCaller
                      ? widget.receiverAvatar
                      : widget.callerAvatar,
                  callDuration: _callDuration,
                  wasRejected: true, // Bị từ chối
                  onClose: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // Remote video hoặc avatar
              if (widget.isVideo && _remoteUid != null && !_isRemoteCameraOff)
                // Remote camera BẬT -> Hiện video
                SizedBox.expand(
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: widget.channelId),
                    ),
                  ),
                )
              else
                // Remote camera TẮT hoặc chưa join -> Hiện avatar
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar
                      if (widget.isCaller)
                        // Caller-> Hiện avatar người nhận
                        if (widget.receiverAvatar != null)
                          CircleAvatar(
                            radius: 40.r,
                            backgroundImage: NetworkImage(
                              widget.receiverAvatar!,
                            ),
                          )
                        else
                          CircleAvatar(
                            radius: 40.r,
                            child: Icon(CupertinoIcons.person, size: 40.sp),
                          )
                      else
                      // Callee -> Hiện avatar người gọi
                      if (widget.callerAvatar != null)
                        CircleAvatar(
                          radius: 40.r,
                          backgroundImage: NetworkImage(widget.callerAvatar!),
                        )
                      else
                        CircleAvatar(
                          radius: 40.r,
                          child: Icon(CupertinoIcons.person, size: 40.sp),
                        ),
                      SizedBox(height: 20.h),

                      // Tên
                      Text(
                        widget.isCaller
                            ? (widget.receiverName ?? 'Unknown')
                            : (widget.callerName ?? 'Unknown'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Trạng thái
                      Text(
                        _remoteUid != null
                            ? (_isRemoteCameraOff
                                  ? 'Camera đã tắt'
                                  : _formatDuration(_callDuration))
                            : (widget.isCaller
                                  ? 'Đang gọi...'
                                  : 'Đang kết nối...'),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),

                      // Countdown cho caller
                      if (widget.isCaller && _isConnecting && _callDuration > 0)
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            '${_callTimeoutSeconds - _callDuration}s',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              // Local video (small floating window)
              if (widget.isVideo && _localUserJoined && !_isCameraOff)
                Positioned(
                  top: 40.h,
                  right: 20.w,
                  child: Container(
                    width: 120.w,
                    height: 160.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      ),
                    ),
                  ),
                ),

              // Top info bar
              Positioned(
                top: 20.h,
                left: 20.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    _formatDuration(_callDuration),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Control buttons at bottom
              Positioned(
                bottom: 40.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute button
                    _buildControlButton(
                      icon: _isMuted
                          ? CupertinoIcons.mic_off
                          : CupertinoIcons.mic,
                      onPressed: _toggleMute,
                      backgroundColor: _isMuted ? Colors.red : Colors.white24,
                    ),

                    // Camera toggle (video call only)
                    if (widget.isVideo)
                      _buildControlButton(
                        icon: _isCameraOff
                            ? Icons.videocam_off_sharp
                            : Icons.videocam_sharp,
                        onPressed: _toggleCamera,
                        backgroundColor: _isCameraOff
                            ? Colors.red
                            : Colors.white24,
                      ),

                    // End call button
                    _buildControlButton(
                      icon: CupertinoIcons.phone_down_fill,
                      onPressed: _endCall,
                      backgroundColor: Colors.red,
                      size: 60.w,
                    ),

                    // Switch camera (video call only)
                    if (widget.isVideo)
                      _buildControlButton(
                        icon: CupertinoIcons.camera_rotate,
                        onPressed: _switchCamera,
                        backgroundColor: Colors.white24,
                      ),

                    // Speaker button with volume indicator
                    _buildSpeakerButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white24,
    double size = 50,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: (size * 0.5).sp),
      ),
    );
  }

  Widget _buildSpeakerButton() {
    // Icon: speaker_3_fill cho loa ngoài, speaker_1_fill cho loa trong
    IconData speakerIcon = _isSpeakerOn
        ? CupertinoIcons
              .speaker_3_fill // Loa ngoài
        : CupertinoIcons.speaker_1_fill; // Loa trong (earpiece)

    return GestureDetector(
      onTap: _toggleSpeaker,
      child: Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: Icon(speakerIcon, color: Colors.white, size: 25.sp),
      ),
    );
  }
}
