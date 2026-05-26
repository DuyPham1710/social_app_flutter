import 'package:social_app_fe/features/video_call/data/data_sources/video_call_remote_data_source.dart';
import 'package:social_app_fe/features/video_call/domain/entities/call_response_entity.dart';
import 'package:social_app_fe/features/video_call/domain/entities/video_call_entities.dart';
import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class VideoCallRepositoryImpl implements VideoCallRepository {
  final VideoCallRemoteDataSource remoteDataSource;

  VideoCallRepositoryImpl({required this.remoteDataSource});

  @override
  void connect(String userId, String username) {
    remoteDataSource.connect(userId, username);
  }

  @override
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 10),
  }) {
    return remoteDataSource.waitForConnection(timeout: timeout);
  }

  @override
  Future<CallResponseEntity> createCall({
    required String userId,
    required String receiverId,
    required String callType,
    String? conversationId,
  }) {
    return remoteDataSource.createCall(
      userId: userId,
      receiverId: receiverId,
      callType: callType,
      conversationId: conversationId,
    );
  }

  @override
  Future<CallTokenEntity> acceptCall({
    required String userId,
    required String callId,
  }) {
    return remoteDataSource.acceptCall(userId: userId, callId: callId);
  }

  @override
  void rejectCall({required String userId, required String callId}) {
    remoteDataSource.rejectCall(userId: userId, callId: callId);
  }

  @override
  void endCall({
    required String userId,
    required String callId,
    int? duration,
    String? callStatus,
  }) {
    remoteDataSource.endCall(
      userId: userId,
      callId: callId,
      duration: duration,
      callStatus: callStatus,
    );
  }

  @override
  Stream<IncomingCallEntity> get onIncomingCall =>
      remoteDataSource.onIncomingCall;

  @override
  Stream<Map<String, dynamic>> get onCallAccepted =>
      remoteDataSource.onCallAccepted;

  @override
  Stream<Map<String, dynamic>> get onCallRejected =>
      remoteDataSource.onCallRejected;

  @override
  Stream<Map<String, dynamic>> get onCallEnded => remoteDataSource.onCallEnded;

  @override
  void disconnect() {
    remoteDataSource.disconnect();
  }

  @override
  void dispose() {
    remoteDataSource.dispose();
  }
}
