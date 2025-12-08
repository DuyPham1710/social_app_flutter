import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import '../../domain/entities/message-edit-log_entity.dart';

class MessageEditLogModel extends MessageEditLogEntity {
  const MessageEditLogModel({
    required super.id,
    required super.messageId,
    required super.oldText,
    required super.newText,
    required super.editedBy,
    required super.editedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory MessageEditLogModel.fromJson(Map<String, dynamic> json) {
    return MessageEditLogModel(
      id: json['_id'] as String,
      messageId: json['messageId'] as String,
      oldText: json['oldText'] as String,
      newText: json['newText'] as String,
      editedBy: UserModel.fromJson(json['editedBy'] as Map<String, dynamic>),
      editedAt: DateTime.parse(json['editedAt'] as String),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'messageId': messageId,
    'oldText': oldText,
    'newText': newText,
    'editedBy': (editedBy as UserModel).toJson(),
    'editedAt': editedAt.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
