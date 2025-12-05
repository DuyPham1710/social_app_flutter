import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/message_response_entity.dart';
import 'package:social_app_fe/features/chat/domain/repository/chat_repository.dart';

class GetMessagesAroundIdUseCase
    implements UseCase<DataState<MessageResponseEntity>, GetMessagesAroundIdParams> {
  final ChatRepository _repository;

  GetMessagesAroundIdUseCase(this._repository);

  @override
  Future<DataState<MessageResponseEntity>> call({
    GetMessagesAroundIdParams? params,
  }) async {
    return await _repository.getMessagesAroundId(
      userId: params!.userId,
      conversationId: params.conversationId,
      messageId: params.messageId,
      limit: params.limit,
    );
  }
}

class GetMessagesAroundIdParams {
  final String userId;
  final String conversationId;
  final String messageId;
  final int limit;

  const GetMessagesAroundIdParams({
    required this.userId,
    required this.conversationId,
    required this.messageId,
    this.limit = 20,
  });
}

