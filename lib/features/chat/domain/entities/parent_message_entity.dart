import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'chat_entities.dart';

class ParentMessageEntity extends Equatable {
  final String id;
  final String text;
  final List<AttachmentEntity> attachments;
  final UserEntity sender;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ParentMessageEntity({
    required this.id,
    required this.text,
    this.attachments = const [],
    required this.sender,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    attachments,
    sender,
    createdAt,
    updatedAt,
  ];
}
