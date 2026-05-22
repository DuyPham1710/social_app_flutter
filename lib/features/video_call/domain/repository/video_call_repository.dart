import 'package:social_app_fe/features/video_call/domain/entities/call_response_entity.dart';
import 'package:social_app_fe/features/video_call/domain/entities/video_call_entities.dart';

abstract class VideoCallRepository {
  void connect(String userId, String username);
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 10),
  });

  Future<CallResponseEntity> createCall({
    required String userId,
    required String receiverId,
    required String callType,
    String? conversationId,
  });

  Future<CallTokenEntity> acceptCall({
    required String userId,
    required String callId,
  });

  void rejectCall({required String userId, required String callId});

  void endCall({
    required String userId,
    required String callId,
    int? duration,
    String? callStatus,
  });

  Stream<IncomingCallEntity> get onIncomingCall;
  Stream<Map<String, dynamic>> get onCallAccepted;
  Stream<Map<String, dynamic>> get onCallRejected;
  Stream<Map<String, dynamic>> get onCallEnded;

  void disconnect();
  void dispose();
}
