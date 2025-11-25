import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/conversation_response_entity.dart';

import '../repository/chat_repository.dart';

class GetConversationsUseCase
    implements
        UseCase<DataState<ConversationResponseEntity>, GetConversationsParams> {
  final ChatRepository _chatRepository;

  GetConversationsUseCase(this._chatRepository);

  @override
  Future<DataState<ConversationResponseEntity>> call({
    GetConversationsParams? params,
  }) async {
    return await _chatRepository.getConversations(
      userId: params!.userId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetConversationsParams {
  final String userId;
  final int page;
  final int limit;

  const GetConversationsParams({
    required this.userId,
    this.page = 1,
    this.limit = 10,
  });
}
