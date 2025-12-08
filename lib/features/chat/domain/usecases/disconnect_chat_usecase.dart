import 'package:social_app_fe/core/usecase/usecase.dart';
import '../repository/chat_repository.dart';

class DisconnectChatUsecase implements UseCase<void, NoParams> {
  final ChatRepository _chatRepository;

  DisconnectChatUsecase(this._chatRepository);

  @override
  Future<void> call({NoParams? params}) async {
    _chatRepository.disconnect();
  }
}
