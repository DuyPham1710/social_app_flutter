import '../../../auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class MessageEditLogEntity extends Equatable {
  final String id;
  final String messageId;
  final String oldText;
  final String newText;
  final UserEntity editedBy;
  final DateTime editedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MessageEditLogEntity({
    required this.id,
    required this.messageId,
    required this.oldText,
    required this.newText,
    required this.editedBy,
    required this.editedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    messageId,
    oldText,
    newText,
    editedBy,
    editedAt,
    createdAt,
    updatedAt,
  ];
}
