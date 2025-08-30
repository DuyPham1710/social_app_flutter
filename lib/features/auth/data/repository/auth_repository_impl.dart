import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/auth/data/data_sources/auth_service.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<DataState<UserModel>> login() {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<DataState<UserModel>> register() {
    // TODO: implement register
    throw UnimplementedError();
  }
}
