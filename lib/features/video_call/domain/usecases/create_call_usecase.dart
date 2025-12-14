import 'package:social_app_fe/features/video_call/domain/entities/call_response_entity.dart';
import 'package:social_app_fe/features/video_call/domain/repository/video_call_repository.dart';

class CreateCallUseCase {
  final VideoCallRepository repository;

  CreateCallUseCase(this.repository);

  Future<CallResponseEntity> call({
    required String userId,
    required String receiverId,
    required String callType,
    String? conversationId,
  }) {
    return repository.createCall(
      userId: userId,
      receiverId: receiverId,
      callType: callType,
      conversationId: conversationId,
    );
  }
}
