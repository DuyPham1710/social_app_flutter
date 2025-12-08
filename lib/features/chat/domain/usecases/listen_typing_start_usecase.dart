import 'package:social_app_fe/core/usecase/usecase.dart';
import '../repository/chat_repository.dart';

/// UseCase để lắng nghe typing:start events
class ListenTypingStartUseCase
    implements StreamUseCase<Map<String, dynamic>, NoParams> {
  final ChatRepository _repository;

  ListenTypingStartUseCase(this._repository);

  @override
  Stream<Map<String, dynamic>> call({required NoParams params}) {
    return _repository.onTypingStart;
  }
}

