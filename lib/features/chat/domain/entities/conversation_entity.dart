import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ConversationEntity extends Equatable {
  final String id;
  final List<UserEntity> participants;
  final bool isGroup;
  final String? name; // nếu là group chat thì tên group
  final UserEntity? createdBy; // người tạo group
  final String? avatar; // nếu là group chat thì avatar group
  final LastMessageEntity? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? unreadCount; // số lượng tin nhắn chưa đọc

  const ConversationEntity({
    required this.id,
    required this.participants,
    required this.isGroup,
    this.name,
    this.createdBy,
    this.avatar,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    this.unreadCount,
  });

  @override
  List<Object?> get props => [
    id,
    participants,
    isGroup,
    name,
    avatar,
    createdBy,
    lastMessage,
    createdAt,
    updatedAt,
    unreadCount,
  ];
}

class LastMessageEntity extends Equatable {
  final String id;
  final String? text;
  final List<AttachmentEntity> attachments;
  final UserEntity sender;
  final DateTime createdAt;

  const LastMessageEntity({
    required this.id,
    this.text,
    this.attachments = const [],
    required this.sender,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, text, attachments, sender, createdAt];
}
