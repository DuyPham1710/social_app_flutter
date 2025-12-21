import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/video_call/domain/entities/call_response_entity.dart';
import 'package:social_app_fe/features/video_call/domain/entities/video_call_entities.dart';

enum VideoCallStatus {
  initial,
  connecting,
  connected,
  creatingCall,
  callCreated,
  incomingCall,
  acceptingCall,
  callAccepted,
  inCall,
  callEnded,
  callRejected,
  error,
  disconnected,
}

class VideoCallState extends Equatable {
  final VideoCallStatus status;
  final CallResponseEntity? activeCall;
  final IncomingCallEntity? incomingCall;
  final CallTokenEntity? tokenEntity;
  final String? errorMessage;

  const VideoCallState({
    this.status = VideoCallStatus.initial,
    this.activeCall,
    this.incomingCall,
    this.tokenEntity,
    this.errorMessage,
  });

  VideoCallState copyWith({
    VideoCallStatus? status,
    CallResponseEntity? activeCall,
    IncomingCallEntity? incomingCall,
    CallTokenEntity? tokenEntity,
    String? errorMessage,
  }) {
    return VideoCallState(
      status: status ?? this.status,
      activeCall: activeCall ?? this.activeCall,
      incomingCall: incomingCall ?? this.incomingCall,
      tokenEntity: tokenEntity ?? this.tokenEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  VideoCallState clearCall() {
    return const VideoCallState(
      status: VideoCallStatus.connected,
      activeCall: null,
      incomingCall: null,
      tokenEntity: null,
      errorMessage: null,
    );
  }

  @override
  List<Object?> get props => [
    status,
    activeCall,
    incomingCall,
    tokenEntity,
    errorMessage,
  ];
}
