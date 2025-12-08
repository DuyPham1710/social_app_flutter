import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/domain/entities/update_user_entity.dart';

abstract class UserRepository {
  Future<DataState<UserEntity>> getUserProfile();
  Future<DataState<UserEntity>> getUserProfileById(String userId);
  Future<DataState<UserEntity>> updateUserProfile(UpdateUserEntity params);

}
