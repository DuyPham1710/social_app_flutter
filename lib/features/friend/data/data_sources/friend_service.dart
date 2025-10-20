import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:social_app_fe/core/constants/constants.dart';
import 'package:social_app_fe/features/friend/data/models/friend_model.dart';
import 'package:social_app_fe/features/friend/data/models/friend_request_model.dart';
import 'package:social_app_fe/features/friend/data/models/friend_suggestion_model.dart';
import 'package:social_app_fe/features/friend/data/models/relationship_status_model.dart';

part 'friend_service.g.dart';

@RestApi()
abstract class FriendService {
  factory FriendService(Dio dio) = _FriendService;

  // Gửi lời mời kết bạn
  @POST('/friends/send-request')
  Future<FriendRequestModel> sendFriendRequest(
    @Body() Map<String, dynamic> request,
  );

  // Chấp nhận lời mời kết bạn
  @POST('/friends/accepted-request')
  Future<Map<String, dynamic>> acceptFriendRequest(
    @Body() Map<String, dynamic> request,
  );

  // Từ chối lời mời kết bạn
  @DELETE('/friends/{requestId}/rejected-request')
  Future<Map<String, dynamic>> rejectFriendRequest(
    @Path('requestId') String requestId,
  );

  // Xóa bạn bè
  @DELETE('/friends/remove')
  Future<Map<String, dynamic>> removeFriend(
    @Body() Map<String, dynamic> request,
  );

  // Lấy danh sách bạn bè
  @GET('/friends/list')
  Future<List<FriendModel>> getFriends();

  // Tìm kiếm bạn bè
  @GET('/friends/search')
  Future<List<FriendModel>> searchFriends(
    @Queries() Map<String, dynamic> queries,
  );

  // Lấy danh sách lời mời đã nhận
  @GET('/friends/requests/received')
  Future<dynamic> getReceivedRequests(@Queries() Map<String, dynamic> queries);

  // Lấy danh sách lời mời đã gửi
  @GET('/friends/requests/sent')
  Future<dynamic> getSentRequests(@Queries() Map<String, dynamic> queries);

  // Hủy lời mời kết bạn đã gửi
  @DELETE('/friends/requests/{requestId}/cancel')
  Future<Map<String, dynamic>> cancelFriendRequest(
    @Path('requestId') String requestId,
  );

  // Kiểm tra trạng thái quan hệ
  @GET('/friends/relationship/{targetUserId}')
  Future<RelationshipStatusModel> getRelationshipStatus(
    @Path('targetUserId') String targetUserId,
  );

  // Lấy danh sách bạn chung
  @GET('/friends/mutual/{targetUserId}')
  Future<Map<String, dynamic>> getMutualFriends(
    @Path('targetUserId') String targetUserId,
    @Queries() Map<String, dynamic> queries,
  );

  // Lấy gợi ý bạn bè
  @GET('/friends/suggestions')
  Future<Map<String, dynamic>> getFriendSuggestions(
    @Queries() Map<String, dynamic> queries,
  );
}
