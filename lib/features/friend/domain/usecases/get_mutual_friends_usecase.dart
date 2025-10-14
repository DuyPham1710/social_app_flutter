import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class GetMutualFriendsUseCase {
  final FriendRepository friendRepository;

  GetMutualFriendsUseCase(this.friendRepository);

  Future<DataState<List<FriendEntity>>> call(String targetUserId, {int limit = 3}) async {
    return await friendRepository.getMutualFriends(targetUserId, limit: limit);
  }
}


