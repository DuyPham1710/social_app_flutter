import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/message-edit-log_entity.dart';
import '../repository/chat_repository.dart';

class GetMessageEditLogsUseCase
    implements
        UseCase<
          DataState<List<MessageEditLogEntity>>,
          GetMessageEditLogsParams
        > {
  final ChatRepository _chatRepository;

  GetMessageEditLogsUseCase(this._chatRepository);

  @override
  Future<DataState<List<MessageEditLogEntity>>> call({
    GetMessageEditLogsParams? params,
  }) async {
    return _chatRepository.getMessageEditLogs(
      userId: params!.userId,
      messageId: params.messageId,
    );
  }
}

class GetMessageEditLogsParams {
  final String userId;
  final String messageId;

  GetMessageEditLogsParams({required this.userId, required this.messageId});
}
