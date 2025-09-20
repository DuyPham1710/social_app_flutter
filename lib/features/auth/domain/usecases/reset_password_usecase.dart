import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/data/models/reset_password_request.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class ResetPasswordUsecase
    implements UseCase<DataState<UserEntity>, ResetPasswordRequest> {
  final AuthRepository _authRepository;

  ResetPasswordUsecase(this._authRepository);

  @override
  Future<DataState<UserEntity>> call({ResetPasswordRequest? params}) {
    return _authRepository.resetPassword(params!);
  }
}
