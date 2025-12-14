import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class IncomingCallEntity extends Equatable {
  final String callId;
  final String channelId;
  final String callerId;
  final UserEntity? callerInfo;
  final String callType;
  final String? conversationId;

  const IncomingCallEntity({
    required this.callId,
    required this.channelId,
    required this.callerId,
    this.callerInfo,
    required this.callType,
    this.conversationId,
  });

  @override
  List<Object?> get props => [
    callId,
    channelId,
    callerId,
    callerInfo,
    callType,
    conversationId,
  ];
}
