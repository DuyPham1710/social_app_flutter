import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/data/models/friend_request_model.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_request_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class GetFriendRequestsUseCase {
  final FriendRepository friendRepository;

  GetFriendRequestsUseCase(this.friendRepository);

  Future<DataState<List<FriendRequestEntity>>> call({
    bool received = true,
  }) async {
    final result = received
        ? await friendRepository.getReceivedRequests()
        : await friendRepository.getSentRequests();

    if (result is DataStateSuccess) {
      // Load mutual friend avatars cho từng request
      final requestsWithAvatars = await _loadMutualFriendAvatars(result.data!);
      return DataStateSuccess(requestsWithAvatars);
    }

    return result;
  }

  Future<List<FriendRequestEntity>> _loadMutualFriendAvatars(
    List<FriendRequestEntity> requests,
  ) async {
    final updatedRequests = <FriendRequestEntity>[];

    for (final request in requests) {
      String? targetUserId;
      if (request.senderId is String) {
        targetUserId = request.senderId as String;
      } else if (request.senderId is Map<String, dynamic>) {
        targetUserId =
            (request.senderId as Map<String, dynamic>)['_id'] as String?;
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
          if (request is FriendRequestModel) {
            final updated = request.copyWith(
              mutualFriendAvatars: avatars,
              mutualFriends: mutualFriendsCount, // Cập nhật số lượng bạn chung
            );
            updatedRequests.add(updated);
          } else {
            updatedRequests.add(request);
          }
        } else {
          // Cập nhật mutualFriends = 0 nếu không có bạn chung
          if (request is FriendRequestModel) {
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
