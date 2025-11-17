import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/friend/domain/entities/relationship_status_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class GetFriendRelationshipUseCase
    implements UseCase<DataState<RelationshipStatusEntity>, String> {
  final FriendRepository _repository;

  GetFriendRelationshipUseCase(this._repository);

  @override
  Future<DataState<RelationshipStatusEntity>> call({String? params}) async {
    if (params == null) throw ArgumentError('UserId cannot be null');
    return await _repository.getRelationshipStatus(params);
  }
}
