import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class EndCallUseCase {
  final VideoCallRepository repository;

  EndCallUseCase(this.repository);

  void call({
    required String userId,
    required String callId,
    int? duration,
    String? callStatus,
  }) {
    repository.endCall(
      userId: userId,
      callId: callId,
      duration: duration,
      callStatus: callStatus,
    );
  }
}
