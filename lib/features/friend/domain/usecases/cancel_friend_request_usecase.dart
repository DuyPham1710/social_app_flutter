import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class CancelFriendRequestUseCase {
  final FriendRepository friendRepository;

  CancelFriendRequestUseCase(this.friendRepository);

  Future<DataState<Map<String, dynamic>>> call(String requestId) async {
    return await friendRepository.cancelFriendRequest(requestId);
  }
}
