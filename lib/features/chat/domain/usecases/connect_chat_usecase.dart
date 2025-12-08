import 'package:social_app_fe/core/usecase/usecase.dart';
import '../repository/chat_repository.dart';

class ConnectChatUseCase implements UseCase<void, ConnectChatSocketParams> {
  final ChatRepository _chatRepository;

  ConnectChatUseCase(this._chatRepository);

  @override
  Future<void> call({ConnectChatSocketParams? params}) async {
    _chatRepository.connect(params!.userId, params.username);
    // Wait for connection to be established
    await _chatRepository.waitForConnection();
  }
}

class ConnectChatSocketParams {
  final String userId;
  final String username;

  const ConnectChatSocketParams(this.userId, this.username);
}
