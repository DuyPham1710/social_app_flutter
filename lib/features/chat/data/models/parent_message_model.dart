import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import '../../domain/entities/parent_message_entity.dart';

class ParentMessageModel {
  final String id;
  final String text;
  final UserModel sender;
  final DateTime createdAt;
  final DateTime updatedAt;

  ParentMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParentMessageModel.fromJson(Map<String, dynamic> json) {
    return ParentMessageModel(
      id: json['_id'] as String,
      text: json['text'] as String,
      sender: UserModel.fromJson(json['senderId'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'text': text,
    'senderId': sender.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  ParentMessageEntity toEntity() => ParentMessageEntity(
    id: id,
    text: text,
    sender: sender.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

