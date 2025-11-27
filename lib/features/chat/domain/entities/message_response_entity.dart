import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';

class MessageResponseEntity {
  final List<MessageEntity> data;
  final PaginatedResponseEntity pagination;

  const MessageResponseEntity({required this.data, required this.pagination});
}
