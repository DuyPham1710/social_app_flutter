import 'chat_media_model.dart';
import 'paginated_response_model.dart';
import '../../domain/entities/chat_media_response_entity.dart';

class ChatMediaResponseModel {
  final List<ChatMediaModel> data;
  final PaginatedResponseModel pagination;

  ChatMediaResponseModel({required this.data, required this.pagination});

  factory ChatMediaResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatMediaResponseModel(
      data: (json['data'] as List)
          .map((item) => ChatMediaModel.fromJson(item as Map<String, dynamic>))
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

  ChatMediaResponseEntity toEntity() => ChatMediaResponseEntity(
    data: data.map((e) => e.toEntity()).toList(),
    pagination: pagination.toEntity(),
  );
}
