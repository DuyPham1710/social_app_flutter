import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/conversation_entity.dart';
import 'parent_message_model.dart';

class AttachmentModel {
  final String url;
  final String type; // image, video, file, audio
  final int size;

  AttachmentModel({required this.url, required this.type, required this.size});

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      url: json['url'] as String,
      type: json['type'] as String,
      size: json['size'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'type': type, 'size': size};

  AttachmentEntity toEntity() =>
      AttachmentEntity(url: url, type: type, size: size);
}

class ReactionModel {
  final UserModel user;
  final EmojiType emoji;

  ReactionModel({required this.user, required this.emoji});

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    // Parse emoji - can be object {id, label, icon} or direct id
    EmojiType emoji = EmojiType.like; // Default

    if (json['emoji'] != null) {
      if (json['emoji'] is Map) {
        final emojiData = json['emoji'] as Map;
        final emojiId = emojiData['id'] as String?;
        if (emojiId != null) {
          emoji = EmojiType.values.firstWhere(
            (e) => e.id == emojiId,
            orElse: () => EmojiType.like,
          );
        }
      } else if (json['emoji'] is String) {
        // Fallback: if emoji is direct string ID
        emoji = EmojiType.values.firstWhere(
          (e) => e.id == json['emoji'],
          orElse: () => EmojiType.like,
        );
      }
    } else if (json['id'] != null) {
      // Fallback: check if id is at root level (old format)
      emoji = EmojiType.values.firstWhere(
        (e) => e.id == json['id'],
        orElse: () => EmojiType.like,
      );
    }

    // Parse user - handle both Map and Map<String, dynamic>
    final userData = json['user'];
    final userMap = userData is Map<String, dynamic>
        ? userData
        : userData is Map
        ? Map<String, dynamic>.from(userData)
        : throw Exception('Invalid user format: ${userData.runtimeType}');

    return ReactionModel(user: UserModel.fromJson(userMap), emoji: emoji);
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'emoji': {'id': emoji.id, 'label': emoji.label, 'icon': emoji.icon},
  };

  ReactionEntity toEntity() =>
      ReactionEntity(user: user.toEntity(), emoji: emoji);
}

class SeenByModel {
  final UserModel user;
  final DateTime seenAt;

  SeenByModel({required this.user, required this.seenAt});

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
  final ParentMessageModel? replyTo;
  final List<ReactionModel> reactions;
  final List<SeenByModel> seenBy;
  final bool deletedForEveryone;
  final List<UserModel>? deletedFor;
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

  // Helper to safely parse list fields
  static List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) parser,
  ) {
    if (data == null) return [];
    if (data is! List) return [];
    if (data.isEmpty) return [];

    return data
        .whereType<Map>()
        .map((item) {
          try {
            final itemMap = item is Map<String, dynamic>
                ? item
                : Map<String, dynamic>.from(item);
            return parser(itemMap);
          } catch (e) {
            print('Error parsing list item: $e');
            return null;
          }
        })
        .whereType<T>()
        .toList();
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Parse replyTo - can be null, a Map (ParentMessageDto), or a string (messageId)
    ParentMessageModel? replyTo;
    if (json['replyTo'] != null) {
      if (json['replyTo'] is Map) {
        try {
          final replyToMap = json['replyTo'] is Map<String, dynamic>
              ? json['replyTo'] as Map<String, dynamic>
              : Map<String, dynamic>.from(json['replyTo'] as Map);
          replyTo = ParentMessageModel.fromJson(replyToMap);
        } catch (e) {
          print('Error parsing replyTo: $e');
          replyTo = null;
        }
      }
      // If replyTo is a string (just messageId), we ignore it as we need full ParentMessageDto
    }

    return MessageModel(
      id: json['_id'] as String,
      conversationId: json['conversationId'] as String?,
      sender: UserModel.fromJson(json['senderId'] as Map<String, dynamic>),
      text: json['text'] as String?,
      attachments: _parseList<AttachmentModel>(
        json['attachments'],
        (item) => AttachmentModel.fromJson(item),
      ),
      replyTo: replyTo,
      reactions: _parseList<ReactionModel>(
        json['reactions'],
        (item) => ReactionModel.fromJson(item),
      ),
      seenBy: _parseList<SeenByModel>(
        json['seenBy'],
        (item) => SeenByModel.fromJson(item),
      ),
      deletedForEveryone: json['deletedForEveryone'] as bool? ?? false,
      deletedFor: _parseList<UserModel>(
        json['deletedFor'],
        (item) => UserModel.fromJson(item),
      ),
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
    'replyTo': replyTo?.toJson(),
    'reactions': reactions.map((e) => e.toJson()).toList(),
    'seenBy': seenBy.map((e) => e.toJson()).toList(),
    'deletedForEveryone': deletedForEveryone,
    'deletedFor': deletedFor?.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  MessageEntity toEntity() => MessageEntity(
    id: id,
    conversationId: conversationId,
    sender: sender.toEntity(),
    text: text,
    attachments: attachments.map((e) => e.toEntity()).toList(),
    replyTo: replyTo?.toEntity(),
    reactions: reactions.map((e) => e.toEntity()).toList(),
    seenBy: seenBy.map((e) => e.toEntity()).toList(),
    deletedForEveryone: deletedForEveryone,
    deletedFor: deletedFor?.map((e) => e.toEntity()).toList(),
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
