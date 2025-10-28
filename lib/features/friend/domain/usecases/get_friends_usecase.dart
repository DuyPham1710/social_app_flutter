import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class GetFriendsUseCase {
  final FriendRepository friendRepository;

  GetFriendsUseCase(this.friendRepository);

  Future<DataState<List<FriendEntity>>> call() async {
    return await friendRepository.getFriends();
  }
}

