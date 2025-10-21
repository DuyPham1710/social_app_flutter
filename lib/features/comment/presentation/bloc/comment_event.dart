import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class JoinPostEvent extends CommentEvent {
  final String postId;

  const JoinPostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class LeavePostEvent extends CommentEvent {
  final String postId;

  const LeavePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class UserTypingEvent extends CommentEvent {
  final String postId;
  final bool isTyping;

  const UserTypingEvent({required this.postId, required this.isTyping});

  @override
  List<Object?> get props => [postId, isTyping];
}

class UpdateTypingUsersEvent extends CommentEvent {
  final String userId;
  final String? username;
  final bool isTyping;

  const UpdateTypingUsersEvent({
    required this.userId,
    required this.username,
    required this.isTyping,
  });

  @override
  List<Object?> get props => [userId, username, isTyping];
}

class AddCommentEvent extends CommentEvent {
  final String postId;
  final String content;
  final String? parentId;

  AddCommentEvent({required this.postId, required this.content, this.parentId});
}
