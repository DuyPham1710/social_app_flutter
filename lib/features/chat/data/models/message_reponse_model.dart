import 'package:social_app_fe/features/chat/data/models/chat_models.dart';
import 'package:social_app_fe/features/chat/domain/entities/message_response_entity.dart';

class MessageReponseModel {
  final List<MessageModel> data;
  final PaginatedResponseModel pagination;

  MessageReponseModel({required this.data, required this.pagination});

  factory MessageReponseModel.fromJson(Map<String, dynamic> json) {
    return MessageReponseModel(
      data: (json['data'] as List)
          .map((item) => MessageModel.fromJson(item as Map<String, dynamic>))
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

  MessageResponseEntity toEntity() => MessageResponseEntity(
    data: data.map((e) => e.toEntity()).toList(),
    pagination: pagination.toEntity(),
  );
}
