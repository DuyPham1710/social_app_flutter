import 'chat_media_entity.dart';
import 'paginated_response_entity.dart';

class ChatMediaResponseEntity {
  final List<ChatMediaEntity> data;
  final PaginatedResponseEntity pagination;

  const ChatMediaResponseEntity({
    required this.data,
    required this.pagination,
  });
}
