import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/video_call/domain/entities/video_call_entities.dart';
import 'package:social_app_fe/features/video_call/presentation/bloc/bloc.dart';
import 'package:social_app_fe/features/video_call/presentation/pages/video_call_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  final IncomingCallEntity callData;
  final String userId;

  const IncomingCallScreen({
    super.key,
    required this.callData,
    required this.userId,
  });

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late VideoCallBloc _videoCallBloc;

  @override
  void initState() {
    super.initState();

    // Setup pulse animation for avatar
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _videoCallBloc = s1<VideoCallBloc>();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToCallScreen(tokenEntity) {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          channelId: tokenEntity.channelId,
          token: tokenEntity.token,
          appId: tokenEntity.appId,
          callId: tokenEntity.callId,
          userId: widget.userId,
          isVideo: widget.callData.callType == 'video',
          isCaller: false,
          callerName:
              widget.callData.callerInfo?.fullName ??
              widget.callData.callerInfo?.username,
          callerAvatar: widget.callData.callerInfo?.avatarUrl,
        ),
      ),
    );
  }

  void _acceptCall() {
    _videoCallBloc.add(
      AcceptCall(userId: widget.userId, callId: widget.callData.callId),
    );
  }

  void _rejectCall() {
    _videoCallBloc.add(
      RejectCall(userId: widget.userId, callId: widget.callData.callId),
    );

    // Close screen
    Navigator.of(context).pop();
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final callerName =
        widget.callData.callerInfo?.fullName ??
        widget.callData.callerInfo?.username ??
        'Unknown';
    final callerAvatar = widget.callData.callerInfo?.avatarUrl;
    final isVideoCall = widget.callData.callType == 'video';

    return BlocListener<VideoCallBloc, VideoCallState>(
      bloc: _videoCallBloc,
      listener: (context, state) {
        if (state.status == VideoCallStatus.inCall &&
            state.tokenEntity != null) {
          _navigateToCallScreen(state.tokenEntity!);
        } else if (state.status == VideoCallStatus.callEnded) {
          // Caller ended the call before receiver picked up (missed call)
          if (mounted) {
            Navigator.of(context).pop();
          }
        } else if (state.status == VideoCallStatus.error) {
          _showError(state.errorMessage ?? 'Unknown error');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Caller avatar with pulse animation
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 80.r,
                        backgroundImage: callerAvatar != null
                            ? NetworkImage(callerAvatar)
                            : null,
                        child: callerAvatar == null
                            ? Icon(
                                CupertinoIcons.person_fill,
                                size: 80.sp,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 30.h),

              // Caller name
              Text(
                callerName,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10.h),

              // Call type
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isVideoCall
                        ? CupertinoIcons.videocam_fill
                        : CupertinoIcons.phone_fill,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isVideoCall ? 'Cuộc gọi video đến' : 'Cuộc gọi thoại đến',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Action buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reject button
                    _buildActionButton(
                      icon: CupertinoIcons.phone_down_fill,
                      label: 'Từ chối',
                      color: Colors.red,
                      onPressed: _rejectCall,
                    ),

                    // Accept button
                    _buildActionButton(
                      icon: isVideoCall
                          ? CupertinoIcons.videocam_fill
                          : CupertinoIcons.phone_fill,
                      label: 'Chấp nhận',
                      color: Colors.green,
                      onPressed: _acceptCall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 35.sp),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
