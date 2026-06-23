import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import '../repository/chat_repository.dart';

class GetConversationMediaUseCase {
  final ChatRepository _chatRepository;

  GetConversationMediaUseCase(this._chatRepository);

  Future<DataState<ChatMediaResponseEntity>> call({
    required String conversationId,
    required String type,
    int page = 1,
    int limit = 30,
  }) {
    return _chatRepository.getConversationMedia(
      conversationId: conversationId,
      type: type,
      page: page,
      limit: limit,
    );
  }
}
