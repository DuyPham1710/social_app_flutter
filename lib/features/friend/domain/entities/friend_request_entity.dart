abstract class FriendRequestEntity {
  String get requestId;
  dynamic get senderId;
  dynamic get receiverId;
  DateTime? get createdAt;
  int? get mutualFriends;
  String? get senderName;
  String? get senderAvatarUrl;
  List<String>? get mutualFriendAvatars;
  
  // Extension getters
  String get displayName {
    if (senderName != null && senderName!.isNotEmpty) {
      return senderName!;
    }
    
    if (senderId is Map<String, dynamic>) {
      final senderData = senderId as Map<String, dynamic>;
      return senderData['fullName'] as String? ?? 'Người dùng';
    }
    
    return 'Người dùng';
  }
  
  String get displayAvatarUrl {
    if (senderAvatarUrl != null && senderAvatarUrl!.isNotEmpty) {
      return senderAvatarUrl!;
    }
    
    if (senderId is Map<String, dynamic>) {
      final senderData = senderId as Map<String, dynamic>;
      return senderData['avatarUrl'] as String? ?? 'https://i.pravatar.cc/150?img=12';
    }
    
    return 'https://i.pravatar.cc/150?img=12';
  }
  
  String? get displayUsername {
    if (senderId is Map<String, dynamic>) {
      final senderData = senderId as Map<String, dynamic>;
      return senderData['username'] as String?;
    }
    return null;
  }
  
  String get formattedTimeAgo {
    if (createdAt == null) return 'Vừa xong';
    
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
  
  int get displayMutualFriends {
    return mutualFriends ?? 0;
  }
}
