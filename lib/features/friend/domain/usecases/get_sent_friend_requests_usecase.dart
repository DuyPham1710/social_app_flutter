import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/data/models/sent_friend_request_model.dart';
import 'package:social_app_fe/features/friend/domain/entities/sent_friend_request_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class GetSentFriendRequestsUseCase {
  final FriendRepository friendRepository;

  GetSentFriendRequestsUseCase(this.friendRepository);

  Future<DataState<List<SentFriendRequestEntity>>> call() async {
    final result = await friendRepository.getSentRequests();

    if (result is DataStateSuccess) {
      // Convert FriendRequestEntity to SentFriendRequestEntity
      final sentRequests = result.data!.map((request) {
        // Tạo SentFriendRequestModel từ data của FriendRequestModel
        return SentFriendRequestModel(
          requestId: request.requestId,
          senderId: request.senderId,
          receiverId: request.receiverId,
          createdAt: request.createdAt,
          mutualFriends: request.mutualFriends,
          receiverName: _getReceiverName(request.receiverId),
          receiverAvatarUrl: _getReceiverAvatarUrl(request.receiverId),
          mutualFriendAvatars: request.mutualFriendAvatars,
        );
      }).toList();

      // Load mutual friend avatars cho từng request
      final requestsWithAvatars = await _loadMutualFriendAvatars(sentRequests);
      return DataStateSuccess(requestsWithAvatars);
    }

    if (result.error != null) {
      return DataStateError(result.error!);
    } else {
      return DataStateError(
        DioException(
          requestOptions: RequestOptions(path: 'unknown'),
          message: 'Unknown error in getSentRequests',
        ),
      );
    }
  }

  String? _getReceiverName(dynamic receiverId) {
    if (receiverId is Map<String, dynamic>) {
      return receiverId['fullName'] as String?;
    }
    return null;
  }

  String? _getReceiverAvatarUrl(dynamic receiverId) {
    if (receiverId is Map<String, dynamic>) {
      return receiverId['avatarUrl'] as String?;
    }
    return null;
  }

  Future<List<SentFriendRequestEntity>> _loadMutualFriendAvatars(
    List<SentFriendRequestEntity> requests,
  ) async {
    final updatedRequests = <SentFriendRequestEntity>[];

    for (final request in requests) {
      String? targetUserId;
      if (request.receiverId is String) {
        targetUserId = request.receiverId as String;
      } else if (request.receiverId is Map<String, dynamic>) {
        targetUserId =
            (request.receiverId as Map<String, dynamic>)['_id'] as String?;
      }

      if (targetUserId != null) {
        // Load mutual friends (tối đa 3)
        final mutualResult = await friendRepository.getMutualFriends(
          targetUserId,
          limit: 3,
        );

        if (mutualResult is DataStateSuccess && mutualResult.data!.isNotEmpty) {
          // Lấy avatarUrl từ mutual friends
          final avatars = mutualResult.data!
              .map(
                (friend) =>
                    friend.avatarUrl ??
                    'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
              )
              .take(3)
              .toList();

          final mutualFriendsCount = mutualResult.data!.length;
          // Tạo request mới với avatars và số lượng bạn chung
          if (request is SentFriendRequestModel) {
            final updated = request.copyWith(
              mutualFriendAvatars: avatars,
              mutualFriends: mutualFriendsCount,
            );
            updatedRequests.add(updated);
          } else {
            updatedRequests.add(request);
          }
        } else {
          // Cập nhật mutualFriends = 0 nếu không có bạn chung
          if (request is SentFriendRequestModel) {
            updatedRequests.add(request.copyWith(mutualFriends: 0));
          } else {
            updatedRequests.add(request);
          }
        }
      } else {
        updatedRequests.add(request);
      }
    }
    return updatedRequests;
  }
}
