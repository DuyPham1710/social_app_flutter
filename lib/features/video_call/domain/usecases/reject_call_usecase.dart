import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class RejectCallUseCase {
  final VideoCallRepository repository;

  RejectCallUseCase(this.repository);

  void call({required String userId, required String callId}) {
    repository.rejectCall(userId: userId, callId: callId);
  }
}
