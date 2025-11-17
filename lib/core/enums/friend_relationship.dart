enum FriendRelationship {
  none,               // Không có quan hệ
  requestReceived,    // Nhận lời mời kết bạn
  friends,            // Đã là bạn bè
  requestSent,        // Đã gửi lời mời kết bạn
}

extension FriendRelationshipX on FriendRelationship {
  static FriendRelationship fromString(String status) {
    switch (status) {
      case 'request_received':
        return FriendRelationship.requestReceived;
      case 'friends':
        return FriendRelationship.friends;
      case 'request_sent':
        return FriendRelationship.requestSent;
      default:
        return FriendRelationship.none;
    }
  }

  String get label {
    switch (this) {
      case FriendRelationship.none:
        return 'Thêm bạn bè';
      case FriendRelationship.requestReceived:
        return 'Chấp nhận kết bạn';
      case FriendRelationship.friends:
        return 'Bạn bè';
      case FriendRelationship.requestSent:
        return 'Hủy yêu cầu kết bạn';
    }
  }
}
