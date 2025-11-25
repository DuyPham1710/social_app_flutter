import 'conversation_model.dart';
import 'paginated_response_model.dart';
import '../../domain/entities/conversation_response_entity.dart';

class ConversationsResponseModel {
  final List<ConversationModel> data;
  final PaginatedResponseModel pagination;

  ConversationsResponseModel({required this.data, required this.pagination});

  factory ConversationsResponseModel.fromJson(Map<String, dynamic> json) {
    return ConversationsResponseModel(
      data: (json['data'] as List)
          .map(
            (item) => ConversationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      pagination: PaginatedResponseModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };

  ConversationResponseEntity toEntity() => ConversationResponseEntity(
    data: data.map((e) => e.toEntity()).toList(),
    pagination: pagination.toEntity(),
  );
}
