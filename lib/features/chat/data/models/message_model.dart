import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/conversation_entity.dart';

class AttachmentModel {
  final String url;
  final String type; // image, video, file, audio
  final int size;

  AttachmentModel({
    required this.url,
    required this.type,
    required this.size,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      url: json['url'] as String,
      type: json['type'] as String,
      size: json['size'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'type': type,
    'size': size,
  };

  AttachmentEntity toEntity() =>
      AttachmentEntity(url: url, type: type, size: size);
}

class ReactionModel {
  final UserModel user;
  final String reaction;

  ReactionModel({
    required this.user,
    required this.reaction,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      reaction: json['reaction'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'reaction': reaction,
  };

  ReactionEntity toEntity() =>
      ReactionEntity(user: user.toEntity(), reaction: reaction);
}

class SeenByModel {
  final UserModel user;
  final DateTime seenAt;

  SeenByModel({
    required this.user,
    required this.seenAt,
  });

  factory SeenByModel.fromJson(Map<String, dynamic> json) {
    return SeenByModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      seenAt: DateTime.parse(json['seenAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'seenAt': seenAt.toIso8601String(),
  };

  SeenByEntity toEntity() =>
      SeenByEntity(user: user.toEntity(), seenAt: seenAt);
}

class MessageModel {
  final String id;
  final String? conversationId;
  final UserModel sender;
  final String? text;
  final List<AttachmentModel> attachments;
  final dynamic replyTo;
  final List<ReactionModel> reactions;
  final List<SeenByModel> seenBy;
  final bool deletedForEveryone;
  final UserModel? deletedFor;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MessageModel({
    required this.id,
    this.conversationId,
    required this.sender,
    this.text,
    this.attachments = const [],
    this.replyTo,
    this.reactions = const [],
    this.seenBy = const [],
    this.deletedForEveryone = false,
    this.deletedFor,
    required this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      conversationId: json['conversationId'] as String?,
      sender: UserModel.fromJson(json['senderId'] as Map<String, dynamic>),
      text: json['text'] as String?,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((item) => AttachmentModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      replyTo: json['replyTo'],
      reactions: json['reactions'] != null
          ? (json['reactions'] as List)
              .map((item) => ReactionModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      seenBy: json['seenBy'] != null
          ? (json['seenBy'] as List)
              .map((item) => SeenByModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      deletedForEveryone: json['deletedForEveryone'] as bool? ?? false,
      deletedFor: json['deletedFor'] != null
          ? UserModel.fromJson(json['deletedFor'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'conversationId': conversationId,
    'senderId': sender.toJson(),
    'text': text,
    'attachments': attachments.map((e) => e.toJson()).toList(),
    'replyTo': replyTo,
    'reactions': reactions.map((e) => e.toJson()).toList(),
    'seenBy': seenBy.map((e) => e.toJson()).toList(),
    'deletedForEveryone': deletedForEveryone,
    'deletedFor': deletedFor?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  MessageEntity toEntity() => MessageEntity(
    id: id,
    conversationId: conversationId,
    sender: sender.toEntity(),
    text: text,
    attachments: attachments.map((e) => e.toEntity()).toList(),
    replyTo: replyTo,
    reactions: reactions.map((e) => e.toEntity()).toList(),
    seenBy: seenBy.map((e) => e.toEntity()).toList(),
    deletedForEveryone: deletedForEveryone,
    deletedFor: deletedFor?.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  // Convert to LastMessageEntity for ConversationEntity
  LastMessageEntity toLastMessageEntity() => LastMessageEntity(
    id: id,
    text: text,
    sender: sender.toEntity(),
    createdAt: createdAt,
  );
}