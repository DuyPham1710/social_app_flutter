import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_request_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class SendFriendRequestUseCase {
  final FriendRepository friendRepository;

  SendFriendRequestUseCase(this.friendRepository);

  Future<DataState<FriendRequestEntity>> call(String receiverId) async {
    return await friendRepository.sendFriendRequest(receiverId);
  }
}
