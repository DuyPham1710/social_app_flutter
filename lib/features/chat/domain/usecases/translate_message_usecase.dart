import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import '../repository/chat_repository.dart';

class TranslateMessageUseCase
    implements
        UseCase<
          DataState<MessageTranslationEntity>,
          TranslateMessageParams
        > {
  final ChatRepository _chatRepository;

  TranslateMessageUseCase(this._chatRepository);

  @override
  Future<DataState<MessageTranslationEntity>> call({
    TranslateMessageParams? params,
  }) async {
    return _chatRepository.translateMessage(
      messageId: params!.messageId,
      targetLang: params.targetLang,
    );
  }
}

class TranslateMessageParams {
  final String messageId;
  final String targetLang;

  TranslateMessageParams({required this.messageId, required this.targetLang});
}
