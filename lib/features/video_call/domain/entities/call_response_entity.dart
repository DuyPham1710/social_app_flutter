import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/video_call/domain/entities/video_call_entities.dart';

class CallResponseEntity extends Equatable {
  final String callId;
  final String channelId;
  final String token;
  final String appId;
  final String callerId;
  final List<String> receiverIds;
  final String callType;
  final String? conversationId;
  final DateTime createdAt;

  const CallResponseEntity({
    required this.callId,
    required this.channelId,
    required this.token,
    required this.appId,
    required this.callerId,
    required this.receiverIds,
    required this.callType,
    this.conversationId,
    required this.createdAt,
  });

  CallTokenEntity toTokenEntity() {
    return CallTokenEntity(
      token: token,
      appId: appId,
      channelId: channelId,
      callId: callId,
    );
  }

  @override
  List<Object?> get props => [
    callId,
    channelId,
    token,
    appId,
    callerId,
    receiverIds,
    callType,
    conversationId,
    createdAt,
  ];
}
