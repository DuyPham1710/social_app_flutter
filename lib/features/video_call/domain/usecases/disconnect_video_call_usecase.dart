import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class DisconnectVideoCallUseCase {
  final VideoCallRepository repository;

  DisconnectVideoCallUseCase(this.repository);

  void call() {
    repository.disconnect();
  }
}
