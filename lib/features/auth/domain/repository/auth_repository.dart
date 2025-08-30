import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<DataState<UserEntity>> login();
  Future<DataState<UserEntity>> register();
}
