// import '../entities/message_entity.dart';
// import '../repository/chat_repository.dart';

// class GetMessagesUseCase {
//   final ChatRepository _repository;

//   GetMessagesUseCase(this._repository);

//   Future<PaginatedResult<MessageEntity>> call({
//     required String userId,
//     required String conversationId,
//     int page = 1,
//     int limit = 50,
//   }) async {
//     return await _repository.getMessages(
//       userId: userId,
//       conversationId: conversationId,
//       page: page,
//       limit: limit,
//     );
//   }
// }
