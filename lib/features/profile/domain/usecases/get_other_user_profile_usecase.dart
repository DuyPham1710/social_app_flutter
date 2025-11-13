import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/domain/repository/user_repository.dart';

class GetOtherUserProfileUseCase
    implements UseCase<DataState<UserEntity>, String> {
  final UserRepository _repository;

  GetOtherUserProfileUseCase(this._repository);

  @override
  Future<DataState<UserEntity>> call({String? params}) async {
    if (params == null) throw ArgumentError('UserId cannot be null');
    return await _repository.getUserProfileById(params);
  }
}
