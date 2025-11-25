import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/chat/domain/entities/conversation_entity.dart';

class LastMessageModel {
  final String id;
  final String? text;
  final UserModel sender;
  final DateTime createdAt;

  LastMessageModel({
    required this.id,
    this.text,
    required this.sender,
    required this.createdAt,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) =>
      LastMessageModel(
        id: json['_id'] as String,
        text: json['text'] as String?,
        sender: UserModel.fromJson(json['senderId'] as Map<String, dynamic>),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'text': text,
    'senderId': sender.toJson(),
    'createdAt': createdAt.toIso8601String(),
  };

  LastMessageEntity toEntity() => LastMessageEntity(
    id: id,
    text: text,
    sender: sender,
    createdAt: createdAt,
  );
}
