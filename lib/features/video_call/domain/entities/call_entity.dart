import 'package:equatable/equatable.dart';

class CallEntity extends Equatable {
  final String callId;
  final String channelId;
  final String callerId;
  final List<String> receiverIds;
  final String callType; // 'video' or 'audio'
  final String? conversationId;
  final DateTime createdAt;

  const CallEntity({
    required this.callId,
    required this.channelId,
    required this.callerId,
    required this.receiverIds,
    required this.callType,
    this.conversationId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    callId,
    channelId,
    callerId,
    receiverIds,
    callType,
    conversationId,
    createdAt,
  ];
}
