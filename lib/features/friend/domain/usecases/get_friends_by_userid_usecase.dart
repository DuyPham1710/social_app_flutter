import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class GetFriendsByUserIdUseCase {
  final FriendRepository repository;
  GetFriendsByUserIdUseCase(this.repository);

  Future<DataState<List<FriendEntity>>> call(String userId) {
    return repository.getFriendsByUserId(userId);
  }
}
