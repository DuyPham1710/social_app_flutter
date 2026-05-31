import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import '../repository/chat_repository.dart';

class GetSummaryUnreadUseCase implements UseCase<DataState<String>, GetSummaryUnreadParams> {
  final ChatRepository _chatRepository;

  GetSummaryUnreadUseCase(this._chatRepository);

  @override
  Future<DataState<String>> call({GetSummaryUnreadParams? params}) async {
    return await _chatRepository.getSummaryUnread(
      conversationId: params!.conversationId,
      messages: params.messages,
      lang: params.lang,
    );
  }
}

class GetSummaryUnreadParams {
  final String conversationId;
  final List<String> messages;
  final String lang;

  const GetSummaryUnreadParams({
    required this.conversationId,
    required this.messages,
    required this.lang,
  });
}
