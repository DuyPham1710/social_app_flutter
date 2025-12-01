import 'package:social_app_fe/features/chat/domain/entities/conversation_entity.dart';
import 'package:social_app_fe/features/chat/domain/entities/paginated_response_entity.dart';

class ConversationResponseEntity {
  final List<ConversationEntity> data;
  final PaginatedResponseEntity pagination;

  const ConversationResponseEntity({
    required this.data,
    required this.pagination,
  });

  ConversationResponseEntity copyWith({
    List<ConversationEntity>? data,
    PaginatedResponseEntity? pagination,
  }) {
    return ConversationResponseEntity(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }
}
