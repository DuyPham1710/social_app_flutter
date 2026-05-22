import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class ConnectVideoCallUseCase {
  final VideoCallRepository repository;

  ConnectVideoCallUseCase(this.repository);

  void call(String userId, String username) {
    repository.connect(userId, username);
  }

  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 10),
  }) {
    return repository.waitForConnection(timeout: timeout);
  }
}
