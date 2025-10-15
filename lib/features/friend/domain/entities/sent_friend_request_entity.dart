abstract class SentFriendRequestEntity {
  String get requestId;
  dynamic get senderId;
  dynamic get receiverId;
  DateTime? get createdAt;
  int? get mutualFriends;
  String? get receiverName;
  String? get receiverAvatarUrl;
  List<String>? get mutualFriendAvatars;
  
  // Extension getters - cho sent request sẽ dùng receiver thay vì sender
  String get displayName {
    if (receiverName != null && receiverName!.isNotEmpty) {
      return receiverName!;
    }
    
    if (receiverId is Map<String, dynamic>) {
      final receiverData = receiverId as Map<String, dynamic>;
      return receiverData['fullName'] as String? ?? 'Người dùng';
    }
    
    return 'Người dùng';
  }
  
  String get displayAvatarUrl {
    if (receiverAvatarUrl != null && receiverAvatarUrl!.isNotEmpty) {
      return receiverAvatarUrl!;
    }
    
    if (receiverId is Map<String, dynamic>) {
      final receiverData = receiverId as Map<String, dynamic>;
      return receiverData['avatarUrl'] as String? ?? 'https://i.pravatar.cc/150?img=12';
    }
    
    return 'https://i.pravatar.cc/150?img=12';
  }
  
  String? get displayUsername {
    if (receiverId is Map<String, dynamic>) {
      final receiverData = receiverId as Map<String, dynamic>;
      return receiverData['username'] as String?;
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

