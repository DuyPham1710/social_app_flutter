// import '../entities/message_entity.dart';
// import '../repository/chat_repository.dart';

// class SendMessageUseCase {
//   final ChatRepository _repository;

//   SendMessageUseCase(this._repository);

//   Future<MessageEntity> call({
//     required String userId,
//     required String conversationId,
//     String? text,
//     List<Map<String, dynamic>>? attachments,
//     String? replyTo,
//   }) async {
//     return await _repository.sendMessage(
//       userId: userId,
//       conversationId: conversationId,
//       text: text,
//       attachments: attachments,
//       replyTo: replyTo,
//     );
//   }
// }
