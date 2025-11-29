import 'package:social_app_fe/core/usecase/usecase.dart';
import '../repository/chat_repository.dart';

/// UseCase để lắng nghe typing:stop events
class ListenTypingStopUseCase
    implements StreamUseCase<Map<String, dynamic>, NoParams> {
  final ChatRepository _repository;

  ListenTypingStopUseCase(this._repository);

  @override
  Stream<Map<String, dynamic>> call({required NoParams params}) {
    return _repository.onTypingStop;
  }
}

