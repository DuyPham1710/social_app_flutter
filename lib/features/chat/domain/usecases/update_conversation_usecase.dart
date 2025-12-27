import '../repository/chat_repository.dart';

class UpdateConversationUseCase {
  final ChatRepository _chatRepository;

  UpdateConversationUseCase(this._chatRepository);

  void call({
    required String userId,
    required String conversationId,
    String? name,
    String? avatar,
    String? createdBy,
    List<String>? participantIds,
  }) {
    _chatRepository.updateConversation(
      userId: userId,
      conversationId: conversationId,
      name: name,
      avatar: avatar,
      createdBy: createdBy,
      participantIds: participantIds,
    );
  }
}
