import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/domain/entities/update_user_entity.dart';
import 'package:social_app_fe/features/profile/domain/repository/user_repository.dart';

class UpdateUserProfileUseCase {
  final UserRepository repository;

  UpdateUserProfileUseCase(this.repository);

  // Return type là DataState
  Future<DataState<UserEntity>> call(UpdateUserEntity params) async {
    return await repository.updateUserProfile(params);
  }
}