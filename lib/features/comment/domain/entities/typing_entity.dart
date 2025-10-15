/// Entity representing a user typing status in the domain layer
class TypingEntity {
  final String userId;
  final String? username;
  final bool isTyping;
  final String postId;

  const TypingEntity({
    required this.userId,
    required this.username,
    required this.isTyping,
    required this.postId,
  });

  @override
  String toString() {
    return 'TypingEntity(userId: $userId, username: $username, isTyping: $isTyping, postId: $postId)';
  }
}

