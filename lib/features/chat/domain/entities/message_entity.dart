import 'package:equatable/equatable.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'parent_message_entity.dart';

class MessageMetadataEntity extends Equatable {
  final String? type;
  final String? callStatus;
  final int? duration;
  final String? callId;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;
  final String? label;

  const MessageMetadataEntity({
    this.type,
    this.callStatus,
    this.duration,
    this.callId,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.label,
  });

  @override
  List<Object?> get props => [
    type,
    callStatus,
    duration,
    callId,
    latitude,
    longitude,
    mapUrl,
    label,
  ];
}

class MessageEntity extends Equatable {
  final String id;
  final String? conversationId;
  final UserEntity sender;
  final String? text;
  final List<AttachmentEntity> attachments;
  final ParentMessageEntity? replyTo;
  final List<ReactionEntity> reactions;
  final List<SeenByEntity> seenBy;
  final bool deletedForEveryone;
  final List<UserEntity>? deletedFor;
  final bool isEdited;
  final MessageMetadataEntity? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const MessageEntity({
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
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    conversationId,
    sender,
    text,
    attachments,
    replyTo,
    reactions,
    seenBy,
    deletedForEveryone,
    deletedFor,
    isEdited,
    metadata,
    createdAt,
    updatedAt,
  ];

  // generate copyWith
  MessageEntity copyWith({
    String? id,
    String? conversationId,
    UserEntity? sender,
    String? text,
    List<AttachmentEntity>? attachments,
    ParentMessageEntity? replyTo,
    List<ReactionEntity>? reactions,
    List<SeenByEntity>? seenBy,
    bool? deletedForEveryone,
    List<UserEntity>? deletedFor,
    bool? isEdited,
    MessageMetadataEntity? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      text: text ?? this.text,
      attachments: attachments ?? this.attachments,
      replyTo: replyTo ?? this.replyTo,
      reactions: reactions ?? this.reactions,
      seenBy: seenBy ?? this.seenBy,
      deletedForEveryone: deletedForEveryone ?? this.deletedForEveryone,
      deletedFor: deletedFor ?? this.deletedFor,
      isEdited: isEdited ?? this.isEdited,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AttachmentEntity extends Equatable {
  final String url;
  final String type; // image, video, file, audio
  final int size;
  final int? duration;
  final List<double>? waveform;

  const AttachmentEntity({
    required this.url,
    required this.type,
    required this.size,
    this.duration,
    this.waveform,
  });

  @override
  List<Object?> get props => [url, type, size, duration, waveform];
}

class ReactionEntity extends Equatable {
  final UserEntity user;
  final EmojiType emoji;

  const ReactionEntity({required this.user, required this.emoji});

  @override
  List<Object?> get props => [user, emoji];
}

class SeenByEntity extends Equatable {
  final UserEntity user;
  final DateTime seenAt;

  const SeenByEntity({required this.user, required this.seenAt});

  @override
  List<Object?> get props => [user, seenAt];
}
