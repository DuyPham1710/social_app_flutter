import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class RemoveFriendUseCase {
  final FriendRepository friendRepository;

  RemoveFriendUseCase(this.friendRepository);

  Future<DataState<Map<String, dynamic>>> call(String friendId) async {
    return await friendRepository.removeFriend(friendId);
  }
}
