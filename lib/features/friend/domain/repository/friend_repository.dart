import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_request_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_suggestion_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/relationship_status_entity.dart';

abstract class FriendRepository {
  // Gửi lời mời kết bạn
  Future<DataState<FriendRequestEntity>> sendFriendRequest(String receiverId);
  
  // Chấp nhận lời mời kết bạn
  Future<DataState<Map<String, dynamic>>> acceptFriendRequest(String requestId);
  
  // Từ chối lời mời kết bạn
  Future<DataState<Map<String, dynamic>>> rejectFriendRequest(String requestId);
  
  // Xóa bạn bè
  Future<DataState<Map<String, dynamic>>> removeFriend(String friendId);
  
  // Lấy danh sách bạn bè
  Future<DataState<List<FriendEntity>>> getFriends();
  
  // Tìm kiếm bạn bè
  Future<DataState<List<FriendEntity>>> searchFriends(String query);
  
  // Lấy danh sách lời mời đã nhận
  Future<DataState<List<FriendRequestEntity>>> getReceivedRequests();
  
  // Lấy danh sách lời mời đã gửi
  Future<DataState<List<FriendRequestEntity>>> getSentRequests();
  
  // Hủy lời mời kết bạn đã gửi
  Future<DataState<Map<String, dynamic>>> cancelFriendRequest(String requestId);
  
  // Kiểm tra trạng thái quan hệ
  Future<DataState<RelationshipStatusEntity>> getRelationshipStatus(String targetUserId);
  
  // Lấy danh sách bạn chung
  Future<DataState<List<FriendEntity>>> getMutualFriends(String targetUserId, {int page = 1, int limit = 10});
  
  // Lấy gợi ý bạn bè
  Future<DataState<List<FriendSuggestionEntity>>> getFriendSuggestions({int page = 1, int limit = 10});
}


