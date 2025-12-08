import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/message_response_entity.dart';
import 'package:social_app_fe/features/chat/domain/repository/chat_repository.dart';

class GetMessagesUseCase
    implements UseCase<DataState<MessageResponseEntity>, GetMessagesParams> {
  final ChatRepository _repository;

  GetMessagesUseCase(this._repository);

  @override
  Future<DataState<MessageResponseEntity>> call({
    GetMessagesParams? params,
  }) async {
    return await _repository.getConversationMessages(
      userId: params!.userId,
      conversationId: params.conversationId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetMessagesParams {
  final String userId;
  final String conversationId;
  final int page;
  final int limit;

  const GetMessagesParams({
    required this.userId,
    required this.conversationId,
    this.page = 1,
    this.limit = 10,
  });
}
