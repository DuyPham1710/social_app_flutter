import 'package:equatable/equatable.dart';

abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object?> get props => [];
}

// Connect to video call socket
class ConnectVideoCall extends VideoCallEvent {
  final String userId;
  final String username;

  const ConnectVideoCall({
    required this.userId,
    required this.username,
  });

  @override
  List<Object?> get props => [userId, username];
}

// Create a call
class CreateCall extends VideoCallEvent {
  final String userId;
  final String receiverId;
  final String callType; // 'video' or 'audio'
  final String? conversationId;

  const CreateCall({
    required this.userId,
    required this.receiverId,
    required this.callType,
    this.conversationId,
  });

  @override
  List<Object?> get props => [userId, receiverId, callType, conversationId];
}

// Accept incoming call
class AcceptCall extends VideoCallEvent {
  final String userId;
  final String callId;

  const AcceptCall({
    required this.userId,
    required this.callId,
  });

  @override
  List<Object?> get props => [userId, callId];
}

// Reject incoming call
class RejectCall extends VideoCallEvent {
  final String userId;
  final String callId;

  const RejectCall({
    required this.userId,
    required this.callId,
  });

  @override
  List<Object?> get props => [userId, callId];
}

// End active call
class EndCall extends VideoCallEvent {
  final String userId;
  final String callId;
  final int? duration; // in seconds
  final String? callStatus; // 'completed', 'missed'

  const EndCall({
    required this.userId,
    required this.callId,
    this.duration,
    this.callStatus,
  });

  @override
  List<Object?> get props => [userId, callId, duration, callStatus];
}

// Incoming call received (from socket)
class IncomingCallReceived extends VideoCallEvent {
  final dynamic callData;

  const IncomingCallReceived(this.callData);

  @override
  List<Object?> get props => [callData];
}

// Call accepted (from socket)
class CallAccepted extends VideoCallEvent {
  final Map<String, dynamic> data;

  const CallAccepted(this.data);

  @override
  List<Object?> get props => [data];
}

// Call rejected (from socket)
class CallRejected extends VideoCallEvent {
  final Map<String, dynamic> data;

  const CallRejected(this.data);

  @override
  List<Object?> get props => [data];
}

// Call ended (from socket)
class CallEnded extends VideoCallEvent {
  final Map<String, dynamic> data;

  const CallEnded(this.data);

  @override
  List<Object?> get props => [data];
}

// Disconnect video call
class DisconnectVideoCall extends VideoCallEvent {
  const DisconnectVideoCall();
}

// Clear call state
class ClearCallState extends VideoCallEvent {
  const ClearCallState();
}

