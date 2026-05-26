import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_request_entity.dart';

part 'friend_request_model.freezed.dart';

@freezed
class FriendRequestModel extends FriendRequestEntity with _$FriendRequestModel {
  FriendRequestModel._(); // Add private constructor for custom getters

  factory FriendRequestModel({
    @JsonKey(name: '_id') required String requestId,
    @JsonKey(name: 'sender_id') required dynamic senderId,
    @JsonKey(name: 'receiver_id') required dynamic receiverId,
    @JsonKey(name: 'createdAt', includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) int? mutualFriends,
    @JsonKey(name: 'sender_name', includeIfNull: false) String? senderName,
    @JsonKey(name: 'sender_avatar_url', includeIfNull: false)
    String? senderAvatarUrl,
    @JsonKey(includeIfNull: false) List<String>? mutualFriendAvatars,
  }) = _FriendRequestModel;

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    // Xử lý sender_id là object hoặc string
    String? senderName;
    String? senderAvatarUrl;
    dynamic senderId;

    if (json['sender_id'] is Map<String, dynamic>) {
      final senderData = json['sender_id'] as Map<String, dynamic>;
      senderId = senderData;
      senderName = senderData['fullName'] as String?;
      senderAvatarUrl = senderData['avatarUrl'] as String?;
    } else {
      senderId = json['sender_id'];
    }

    // Xử lý receiver_id tương tự
    dynamic receiverId = json['receiver_id'];
    if (json['receiver_id'] is Map<String, dynamic>) {
      receiverId = json['receiver_id'];
    }

    // Xử lý mutualFriends - backend có thể trả về 'mutualFriends' hoặc 'mutualFriendsCount'
    int? mutualFriends;
    if (json.containsKey('mutualFriendsCount')) {
      mutualFriends = (json['mutualFriendsCount'] as num?)?.toInt();
    } else if (json.containsKey('mutualFriends')) {
      mutualFriends = (json['mutualFriends'] as num?)?.toInt();
    }

    return FriendRequestModel(
      requestId: json['_id'] as String,
      senderId: senderId,
      receiverId: receiverId,
      createdAt: _parseDateTime(json['createdAt']),
      mutualFriends: mutualFriends,
      senderName: senderName,
      senderAvatarUrl: senderAvatarUrl,
      mutualFriendAvatars: null, // Sẽ được load sau
    );
  }

  /// Parse DateTime từ nhiều format khác nhau
  static DateTime? _parseDateTime(dynamic dateTimeValue) {
    if (dateTimeValue == null) return null;

    try {
      if (dateTimeValue is String) {
        return DateTime.parse(dateTimeValue);
      } else if (dateTimeValue is Map<String, dynamic>) {
        // Xử lý trường hợp createdAt là object với $date
        if (dateTimeValue.containsKey('\$date')) {
          return DateTime.parse(dateTimeValue['\$date'] as String);
        }
      }
      return null;
    } catch (e) {
      print('Error parsing DateTime: $dateTimeValue, Error: $e');
      return null;
    }
  }
}
