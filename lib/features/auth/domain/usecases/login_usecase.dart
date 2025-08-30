import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class LoginUsecase implements UseCase<DataState<UserEntity>, void> {
  final AuthRepository _authRepository;

  LoginUsecase(this._authRepository);

  @override
  Future<DataState<UserEntity>> call({void params}) {
    return _authRepository.login();
  }
}
