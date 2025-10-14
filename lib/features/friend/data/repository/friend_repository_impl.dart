import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/data/data_sources/friend_service.dart';
import 'package:social_app_fe/features/friend/data/models/friend_model.dart';
import 'package:social_app_fe/features/friend/data/models/friend_request_model.dart';
import 'package:social_app_fe/features/friend/data/models/friend_suggestion_model.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_request_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_suggestion_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/relationship_status_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendService friendService;

  FriendRepositoryImpl(this.friendService);

  @override
  Future<DataState<FriendRequestEntity>> sendFriendRequest(String receiverId) async {
    try {
      final response = await friendService.sendFriendRequest({'receiver_id': receiverId});
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> acceptFriendRequest(String requestId) async {
    try {
      final response = await friendService.acceptFriendRequest({'request_id': requestId});
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> rejectFriendRequest(String requestId) async {
    try {
      final response = await friendService.rejectFriendRequest(requestId);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> removeFriend(String friendId) async {
    try {
      final response = await friendService.removeFriend({'friend_id': friendId});
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<FriendEntity>>> getFriends() async {
    try {
      final response = await friendService.getFriends();
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<FriendEntity>>> searchFriends(String query) async {
    try {
      final response = await friendService.searchFriends({'query': query});
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<FriendRequestEntity>>> getReceivedRequests() async {
    return await _getFriendRequests(isReceived: true);
  }
  
  /// Helper method để xử lý lấy danh sách friend requests
  Future<DataState<List<FriendRequestEntity>>> _getFriendRequests({
    required bool isReceived,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queries = {
        'page': page,
        'limit': limit,
        'sort': 'createdAt',
        'order': 'desc',
      };

      final response = isReceived 
          ? await friendService.getReceivedRequests(queries)
          : await friendService.getSentRequests(queries);

      List<dynamic>? data = _extractDataFromResponse(response);
      
      if (data != null && data.isNotEmpty) {
        final requestModels = <FriendRequestEntity>[];
        
        for (final json in data) {
          try {
            final requestModel = FriendRequestModel.fromJson(json as Map<String, dynamic>);
            requestModels.add(requestModel);
          } catch (e) {
            continue;
          }
        }
        
        return DataStateSuccess(requestModels);
      }
      return DataStateSuccess([]);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return DataStateError(DioException(
          requestOptions: e.requestOptions,
          message: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
        ));
      } else if (e.response?.statusCode == 404) {
        return DataStateSuccess([]); // Không có lời mời nào
      } else if (e.response?.statusCode == 500) {
        return DataStateError(DioException(
          requestOptions: e.requestOptions,
          message: 'Lỗi máy chủ. Vui lòng thử lại sau.',
        ));
      }
      
      return DataStateError(e);
    } catch (e) {
      return DataStateError(DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.',
      ));
    }
  }
  
  /// Helper method để extract data từ response
  List<dynamic>? _extractDataFromResponse(dynamic response) {
    if (response == null) {
      return null;
    }
    // Xử lý trường hợp response là Map (format chuẩn từ backend)
    if (response is Map<String, dynamic>) {
      // Kiểm tra các key có thể chứa data
      final possibleKeys = ['data', 'requests', 'friendRequests', 'results'];
      
      for (final key in possibleKeys) {
        if (response.containsKey(key)) {
          final value = response[key];
          if (value is List<dynamic>) {
            return value;
          }
        }
      }
      return null;
    }
    
    // Xử lý trường hợp response là List trực tiếp (có thể là list wrapped objects)
    if (response is List<dynamic>) {
      if (response.isEmpty) {
        return response;
      }
      
      // Kiểm tra xem item đầu tiên có phải là wrapper object không
      final firstItem = response.first;
      if (firstItem is Map<String, dynamic>) {
        // Nếu có statusCode và data key, đây là wrapped response
        if (firstItem.containsKey('statusCode') && firstItem.containsKey('data')) {
          final data = firstItem['data'];
          if (data is List<dynamic>) {
            return data;
          }
        }
      }
      return response;
    }
    return null;
  }

  @override
  Future<DataState<List<FriendRequestEntity>>> getSentRequests() async {
    return await _getFriendRequests(isReceived: false);
  }

  @override
  Future<DataState<Map<String, dynamic>>> cancelFriendRequest(String requestId) async {
    try {
      final response = await friendService.cancelFriendRequest(requestId);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<RelationshipStatusEntity>> getRelationshipStatus(String targetUserId) async {
    try {
      final response = await friendService.getRelationshipStatus(targetUserId);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<FriendEntity>>> getMutualFriends(String targetUserId, {int page = 1, int limit = 10}) async {
    try {
      final response = await friendService.getMutualFriends(targetUserId, {'page': page, 'limit': limit});
      // Retrofit đã unwrap và trả về {mutualFriends: [...], pagination: {...}}
      if (response.containsKey('mutualFriends')) {
        final mutualFriendsJson = response['mutualFriends'] as List<dynamic>?;
        
        // Lấy total count từ pagination (nếu có)
        int? totalCount;
        if (response.containsKey('pagination')) {
          final pagination = response['pagination'] as Map<String, dynamic>?;
          totalCount = pagination?['totalItems'] as int?;
        }
        
        if (mutualFriendsJson != null && mutualFriendsJson.isNotEmpty) {
          // Parse từng friend JSON thành FriendModel
          final friends = mutualFriendsJson
              .map((json) => FriendModel.fromJson(json as Map<String, dynamic>))
              .toList();
          return DataStateSuccess(friends);
        }
      }
      return DataStateSuccess([]);
    } on DioException catch (e) {
      return DataStateError(e);
    } catch (e) {
      return DataStateSuccess([]);
    }
  }

  @override
  Future<DataState<List<FriendSuggestionEntity>>> getFriendSuggestions({int page = 1, int limit = 10}) async {
    try {
      final response = await friendService.getFriendSuggestions({'page': page, 'limit': limit});
      if (response is Map<String, dynamic>) {
        List<dynamic>? suggestions;

        if (response.containsKey('suggestions')) {
          suggestions = response['suggestions'] as List<dynamic>?;
        }
        else if (response.containsKey('data')) {
          final data = response['data'] as Map<String, dynamic>?;
          suggestions = data?['suggestions'] as List<dynamic>?;
        }
        
        if (suggestions != null) {
          // Parse each suggestion to FriendSuggestionModel
          final suggestionModels = suggestions.map((json) => 
            FriendSuggestionModel.fromJson(json as Map<String, dynamic>)
          ).toList();
          return DataStateSuccess(suggestionModels);
        }
      }
      return DataStateSuccess([]);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
