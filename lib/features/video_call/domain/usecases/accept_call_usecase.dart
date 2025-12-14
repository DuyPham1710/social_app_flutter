import 'package:social_app_fe/features/video_call/domain/entities/video_call_entities.dart';
import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class AcceptCallUseCase {
  final VideoCallRepository repository;

  AcceptCallUseCase(this.repository);

  Future<CallTokenEntity> call({
    required String userId,
    required String callId,
  }) {
    return repository.acceptCall(userId: userId, callId: callId);
  }
}
