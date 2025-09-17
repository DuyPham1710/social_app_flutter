import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class UpdatePersonalInfoUsecase
    implements UseCase<DataState<UserEntity>, UserEntity> {
  final AuthRepository _authRepository;

  UpdatePersonalInfoUsecase(this._authRepository);

  @override
  Future<DataState<UserEntity>> call({UserEntity? params}) {
    return _authRepository.updatePersonalInfo(params!);
  }
}
