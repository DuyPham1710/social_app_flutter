import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import '../repository/chat_repository.dart';

class CreateConversationUseCase
    implements UseCase<DataState<ConversationEntity>, CreateConversationParams> {
  final ChatRepository _chatRepository;

  CreateConversationUseCase(this._chatRepository);

  @override
  Future<DataState<ConversationEntity>> call({
    CreateConversationParams? params,
  }) async {
    return _chatRepository.createConversation(
      userId: params!.userId,
      participantIds: params.participantIds,
      isGroup: params.isGroup,
      name: params.name,
      avatar: params.avatar,
    );
  }
}

class CreateConversationParams {
  final String userId;
  final List<String> participantIds;
  final bool isGroup;
  final String? name;
  final String? avatar;

  CreateConversationParams({
    required this.userId,
    required this.participantIds,
    this.isGroup = false,
    this.name,
    this.avatar,
  });
}

