import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class ListenCallRejectedUseCase {
  final VideoCallRepository repository;

  ListenCallRejectedUseCase(this.repository);

  Stream<Map<String, dynamic>> call() {
    return repository.onCallRejected;
  }
}
