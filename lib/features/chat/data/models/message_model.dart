import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/post/data/models/post_model.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/conversation_entity.dart';
import 'parent_message_model.dart';
import 'story_reply_model.dart';

class AttachmentModel {
  final String url;
  final String type; // image, video, file, audio
  final int size;
  final String? name;
  final int? duration; // For audio/video
  final List<double>? waveform; // For audio messages

  AttachmentModel({
    required this.url,
    required this.type,
    required this.size,
    this.name,
    this.duration,
    this.waveform,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      url: json['url'] as String,
      type: json['type'] as String,
      size: json['size'] as int,
      name: json['name'] as String?,
      duration: json['duration'] as int?,
      waveform: (json['waveform'] as List<dynamic>?)
          ?.whereType<num>()
          .map((v) => v.toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'type': type,
    'size': size,
    'name': name,
    'duration': duration,
    'waveform': waveform,
  };

  AttachmentEntity toEntity() => AttachmentEntity(
    url: url,
    type: type,
    size: size,
    name: name,
    duration: duration,
    waveform: waveform,
  );
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

class MessageMetadataModel {
  final String? type; // 'video_call' | 'audio_call' | 'location'
  final String? callStatus; // 'completed', 'missed', 'rejected'
  final int? duration; // in seconds
  final String? callId;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;
  final String? label;

  MessageMetadataModel({
    this.type,
    this.callStatus,
    this.duration,
    this.callId,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.label,
  });

  factory MessageMetadataModel.fromJson(Map<String, dynamic> json) {
    return MessageMetadataModel(
      type: json['type'] as String?,
      callStatus: json['callStatus'] as String?,
      duration: json['duration'] as int?,
      callId: json['callId'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      mapUrl: json['mapUrl'] as String?,
      label: json['label'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'callStatus': callStatus,
    'duration': duration,
    'callId': callId,
    'latitude': latitude,
    'longitude': longitude,
    'mapUrl': mapUrl,
    'label': label,
  };

  MessageMetadataEntity toEntity() => MessageMetadataEntity(
    type: type,
    callStatus: callStatus,
    duration: duration,
    callId: callId,
    latitude: latitude,
    longitude: longitude,
    mapUrl: mapUrl,
    label: label,
  );
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
  final bool isEdited;
  final MessageMetadataModel? metadata;
  final StoryReplyModel? story;
  final PostModel? post;
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
    this.isEdited = false,
    this.metadata,
    this.story,
    this.post,
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

    // Parse metadata if present
    MessageMetadataModel? metadata;
    if (json['metadata'] != null && json['metadata'] is Map) {
      try {
        final metadataMap = json['metadata'] is Map<String, dynamic>
            ? json['metadata'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['metadata'] as Map);
        metadata = MessageMetadataModel.fromJson(metadataMap);
      } catch (e) {
        print('Error parsing metadata: $e');
        metadata = null;
      }
    }

    // Parse story if present
    StoryReplyModel? story;
    if (json['story'] != null && json['story'] is Map) {
      try {
        final storyMap = json['story'] is Map<String, dynamic>
            ? json['story'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['story'] as Map);
        story = StoryReplyModel.fromJson(storyMap);
      } catch (e) {
        print('Error parsing story reply: $e');
        story = null;
      }
    } else if (json['storyId'] != null && json['storyId'] is Map) {
      // Fallback if backend returned populated story inside storyId field
      try {
        final storyMap = json['storyId'] is Map<String, dynamic>
            ? json['storyId'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['storyId'] as Map);
        story = StoryReplyModel.fromJson(storyMap);
      } catch (e) {
        print('Error parsing storyId as story: $e');
        story = null;
      }
    }

    // Parse post if present
    PostModel? post;
    if (json['post'] != null && json['post'] is Map) {
      try {
        final postMap = json['post'] is Map<String, dynamic>
            ? json['post'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['post'] as Map);
            
        // Map string array urls to PostUrlModel objects
        if (postMap['urls'] is List) {
          postMap['urls'] = (postMap['urls'] as List).map((item) {
            if (item is Map) {
              return item;
            } else {
              return {
                '_id': item.toString(),
                'url': item.toString(),
                'order': 0,
              };
            }
          }).toList();
        }
        
        post = PostModel.fromJson(postMap);
      } catch (e) {
        print('Error parsing post share: $e');
        post = null;
      }
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
      isEdited: json['isEdited'] as bool? ?? false,
      metadata: metadata,
      story: story,
      post: post,
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
    'isEdited': isEdited,
    'metadata': metadata?.toJson(),
    'story': story?.toJson(),
    'post': post?.toJson(),
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
    isEdited: isEdited,
    metadata: metadata?.toEntity(),
    story: story?.toEntity(),
    post: post,
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
