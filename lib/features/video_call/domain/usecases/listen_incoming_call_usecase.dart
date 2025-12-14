import 'package:social_app_fe/features/video_call/domain/entities/incoming_call_entity.dart';
import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class ListenIncomingCallUseCase {
  final VideoCallRepository repository;

  ListenIncomingCallUseCase(this.repository);

  Stream<IncomingCallEntity> call() {
    return repository.onIncomingCall;
  }
}
