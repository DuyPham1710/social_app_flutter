import 'package:equatable/equatable.dart';

class TypingUser {
  final String userId;
  final String? username;

  const TypingUser({required this.userId, this.username});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypingUser &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

abstract class CommentState extends Equatable {
  final String? postId;
  final Set<TypingUser> typingUsers;

  const CommentState({this.postId, this.typingUsers = const {}});

  @override
  List<Object?> get props => [postId, typingUsers];
}

class CommentInitial extends CommentState {}

class CommentJoined extends CommentState {
  const CommentJoined({required String super.postId, super.typingUsers});
}
