import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import '../repository/chat_repository.dart';

class LeaveConversationUseCase
    implements UseCase<DataState<void>, LeaveConversationParams> {
  final ChatRepository _chatRepository;

  LeaveConversationUseCase(this._chatRepository);

  @override
  Future<DataState<void>> call({LeaveConversationParams? params}) async {
    return await _chatRepository.leaveConversation(
      conversationId: params!.conversationId,
    );
  }
}

class LeaveConversationParams {
  final String conversationId;

  const LeaveConversationParams({required this.conversationId});
}
