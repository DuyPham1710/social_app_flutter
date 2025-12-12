import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/chat/data/models/chat_models.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';

class LastMessageModel {
  final String id;
  final String? text;
  final List<AttachmentModel> attachments;
  final UserModel sender;
  final DateTime createdAt;

  LastMessageModel({
    required this.id,
    this.text,
    this.attachments = const [],
    required this.sender,
    required this.createdAt,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) =>
      LastMessageModel(
        id: json['_id'] as String,
        text: json['text'] as String?,
        attachments: json['attachments'] != null
            ? (json['attachments'] as List)
                  .map(
                    (e) => AttachmentModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList()
            : [],
        sender: UserModel.fromJson(json['senderId'] as Map<String, dynamic>),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'text': text,
    'attachments': attachments.map((e) => e.toJson()).toList(),
    'senderId': sender.toJson(),
    'createdAt': createdAt.toIso8601String(),
  };

  LastMessageEntity toEntity() => LastMessageEntity(
    id: id,
    text: text,
    attachments: attachments.map((e) => e.toEntity()).toList(),
    sender: sender,
    createdAt: createdAt,
  );
}
