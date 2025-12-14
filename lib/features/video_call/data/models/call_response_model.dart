import 'package:social_app_fe/features/video_call/domain/entities/call_response_entity.dart';

class CallResponseModel {
  final String callId;
  final String channelId;
  final String token;
  final String appId;
  final String callerId;
  final List<String> receiverIds;
  final String callType;
  final String? conversationId;
  final DateTime createdAt;

  CallResponseModel({
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

  factory CallResponseModel.fromJson(Map<String, dynamic> json) {
    return CallResponseModel(
      callId: json['callId'] as String,
      channelId: json['channelId'] as String,
      token: json['token'] as String,
      appId: json['appId'] as String,
      callerId: json['callerId'] as String,
      receiverIds: (json['receiverIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      callType: json['callType'] as String,
      conversationId: json['conversationId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  CallResponseEntity toEntity() {
    return CallResponseEntity(
      callId: callId,
      channelId: channelId,
      token: token,
      appId: appId,
      callerId: callerId,
      receiverIds: receiverIds,
      callType: callType,
      conversationId: conversationId,
      createdAt: createdAt,
    );
  }
}
