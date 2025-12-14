import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class ListenCallEndedUseCase {
  final VideoCallRepository repository;

  ListenCallEndedUseCase(this.repository);

  Stream<Map<String, dynamic>> call() {
    return repository.onCallEnded;
  }
}
