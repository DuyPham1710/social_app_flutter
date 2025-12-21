import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/chat/data/models/last_message_model.dart';
import '../../domain/entities/conversation_entity.dart';

class ConversationModel {
  final String id;
  final List<UserModel> participants;
  final bool isGroup;
  final String? name;
  final String? avatar;
  final UserModel? createdBy;
  final LastMessageModel? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? unreadCount;
  final int? firstUnreadMessageIndex;

  ConversationModel({
    required this.id,
    required this.participants,
    required this.isGroup,
    this.name,
    this.avatar,
    this.createdBy,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    this.unreadCount,
    this.firstUnreadMessageIndex,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json['_id'] as String,
        participants: (json['participants'] as List)
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        isGroup: json['isGroup'] as bool,
        name: json['name'] as String?,
        avatar: json['avatar'] as String?,
        createdBy: json['createdBy'] != null
            ? UserModel.fromJson(json['createdBy'] as Map<String, dynamic>)
            : null,
        lastMessage: json['lastMessageId'] != null
            ? LastMessageModel.fromJson(
                json['lastMessageId'] as Map<String, dynamic>,
              )
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(), // hoặc null nếu bạn muốn
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : DateTime.now(),
        unreadCount: json['unreadCount'] as int?,
        firstUnreadMessageIndex: json['firstUnreadMessageIndex'] as int?,
      );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'participants': participants.map((e) => e.toJson()).toList(),
    'isGroup': isGroup,
    'name': name,
    'avatar': avatar,
    'createdBy': createdBy?.toJson(),
    'lastMessageId': lastMessage?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'unreadCount': unreadCount,
    'firstUnreadMessageIndex': firstUnreadMessageIndex,
  };

  ConversationEntity toEntity() => ConversationEntity(
    id: id,
    participants: participants,
    isGroup: isGroup,
    name: name,
    avatar: avatar,
    createdBy: createdBy,
    lastMessage: lastMessage?.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
    unreadCount: unreadCount,
    firstUnreadMessageIndex: firstUnreadMessageIndex,
  );
}
