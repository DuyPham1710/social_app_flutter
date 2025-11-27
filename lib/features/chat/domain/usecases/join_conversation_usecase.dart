import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import '../repository/chat_repository.dart';

class JoinConversationUseCase implements UseCase<DataState<void>, JoinConversationParams> {
  final ChatRepository _chatRepository;

  JoinConversationUseCase(this._chatRepository);

  @override
  Future<DataState<void>> call({JoinConversationParams? params}) async {
    return await _chatRepository.joinConversation(
      userId: params!.userId,
      conversationId: params.conversationId,
    );
  }
}

class JoinConversationParams {
  final String userId;
  final String conversationId;

  const JoinConversationParams({
    required this.userId,
    required this.conversationId,
  });
}
