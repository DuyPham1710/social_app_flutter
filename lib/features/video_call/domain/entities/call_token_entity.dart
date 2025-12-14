import 'package:equatable/equatable.dart';

class CallTokenEntity extends Equatable {
  final String token;
  final String appId;
  final String channelId;
  final String callId;

  const CallTokenEntity({
    required this.token,
    required this.appId,
    required this.channelId,
    required this.callId,
  });

  @override
  List<Object?> get props => [token, appId, channelId, callId];
}
