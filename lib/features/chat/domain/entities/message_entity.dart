import 'package:equatable/equatable.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import '../../../auth/domain/entities/user_entity.dart';

class MessageEntity extends Equatable {
  final String id;
  final String? conversationId;
  final UserEntity sender;
  final String? text;
  final List<AttachmentEntity> attachments;
  final dynamic replyTo; // Can be expanded to MessageEntity if needed
  final List<ReactionEntity> reactions;
  final List<SeenByEntity> seenBy;
  final bool deletedForEveryone;
  final List<UserEntity>? deletedFor;
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
    createdAt,
    updatedAt,
  ];
}

class AttachmentEntity extends Equatable {
  final String url;
  final String type; // image, video, file, audio
  final int size;

  const AttachmentEntity({
    required this.url,
    required this.type,
    required this.size,
  });

  @override
  List<Object?> get props => [url, type, size];
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
