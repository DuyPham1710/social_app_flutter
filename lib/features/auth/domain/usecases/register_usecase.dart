import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/data/models/register_request.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class RegisterUsecase
    implements UseCase<DataState<UserEntity>, RegisterRequest> {
  final AuthRepository _authRepository;

  RegisterUsecase(this._authRepository);

  @override
  Future<DataState<UserEntity>> call({RegisterRequest? params}) {
    return _authRepository.register(params!);
  }
}
