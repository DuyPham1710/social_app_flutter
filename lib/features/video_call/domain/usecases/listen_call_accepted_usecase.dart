import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class ListenCallAcceptedUseCase {
  final VideoCallRepository repository;

  ListenCallAcceptedUseCase(this.repository);

  Stream<Map<String, dynamic>> call() {
    return repository.onCallAccepted;
  }
}
