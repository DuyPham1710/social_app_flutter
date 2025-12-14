import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/video_call/domain/entities/video_call_entities.dart';

class IncomingCallModel {
  final String callId;
  final String channelId;
  final String callerId;
  final UserModel? callerInfo;
  final String callType;
  final String? conversationId;

  IncomingCallModel({
    required this.callId,
    required this.channelId,
    required this.callerId,
    this.callerInfo,
    required this.callType,
    this.conversationId,
  });

  factory IncomingCallModel.fromJson(Map<String, dynamic> json) {
    return IncomingCallModel(
      callId: json['callId'] as String,
      channelId: json['channelId'] as String,
      callerId: json['callerId'] as String,
      callerInfo: json['callerInfo'] != null
          ? UserModel.fromJson(json['callerInfo'] as Map<String, dynamic>)
          : null,
      callType: json['callType'] as String,
      conversationId: json['conversationId'] as String?,
    );
  }

  IncomingCallEntity toEntity() {
    return IncomingCallEntity(
      callId: callId,
      channelId: channelId,
      callerId: callerId,
      callerInfo: callerInfo?.toEntity(),
      callType: callType,
      conversationId: conversationId,
    );
  }
}
