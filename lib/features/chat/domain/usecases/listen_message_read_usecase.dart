import 'package:social_app_fe/core/usecase/usecase.dart';
import '../repository/chat_repository.dart';

/// UseCase để lắng nghe message:read events
class ListenMessageReadUseCase
    implements StreamUseCase<Map<String, dynamic>, NoParams> {
  final ChatRepository _repository;

  ListenMessageReadUseCase(this._repository);

  @override
  Stream<Map<String, dynamic>> call({required NoParams params}) {
    return _repository.onMessageRead;
  }
}

