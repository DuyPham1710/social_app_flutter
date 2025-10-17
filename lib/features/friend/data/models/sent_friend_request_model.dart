import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/friend/domain/entities/sent_friend_request_entity.dart';

part 'sent_friend_request_model.freezed.dart';

@freezed
class SentFriendRequestModel extends SentFriendRequestEntity with _$SentFriendRequestModel {
  SentFriendRequestModel._(); // Add private constructor for custom getters
  
   factory SentFriendRequestModel({
    @JsonKey(name: '_id') required String requestId,
    @JsonKey(name: 'sender_id') required dynamic senderId,
    @JsonKey(name: 'receiver_id') required dynamic receiverId,
    @JsonKey(name: 'createdAt', includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) int? mutualFriends,
    @JsonKey(name: 'receiver_name', includeIfNull: false) String? receiverName,
    @JsonKey(name: 'receiver_avatar_url', includeIfNull: false) String? receiverAvatarUrl,
    @JsonKey(includeIfNull: false) List<String>? mutualFriendAvatars,
  }) = _SentFriendRequestModel;

  factory SentFriendRequestModel.fromJson(Map<String, dynamic> json) {
    // Xử lý receiver_id là object hoặc string
    String? receiverName;
    String? receiverAvatarUrl;
    dynamic receiverId;
    
    if (json['receiver_id'] is Map<String, dynamic>) {
      final receiverData = json['receiver_id'] as Map<String, dynamic>;
      receiverId = receiverData;
      receiverName = receiverData['fullName'] as String?;
      receiverAvatarUrl = receiverData['avatarUrl'] as String?;
    } else {
      receiverId = json['receiver_id'];
    }
    
    // Xử lý sender_id
    dynamic senderId = json['sender_id'];
    if (json['sender_id'] is Map<String, dynamic>) {
      senderId = json['sender_id'];
    }
    
    // Xử lý mutualFriends
    int? mutualFriends;
    if (json.containsKey('mutualFriendsCount')) {
      mutualFriends = (json['mutualFriendsCount'] as num?)?.toInt();
    } else if (json.containsKey('mutualFriends')) {
      mutualFriends = (json['mutualFriends'] as num?)?.toInt();
    }
    
    return SentFriendRequestModel(
      requestId: json['_id'] as String,
      senderId: senderId,
      receiverId: receiverId,
      createdAt: _parseDateTime(json['createdAt']),
      mutualFriends: mutualFriends,
      receiverName: receiverName,
      receiverAvatarUrl: receiverAvatarUrl,
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



