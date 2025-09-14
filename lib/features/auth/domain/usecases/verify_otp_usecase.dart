import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/data/models/verify_otp_request.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class VerifyOtpUsecase
    implements UseCase<DataState<UserEntity>, VerifyOtpRequest> {
  final AuthRepository _authRepository;

  VerifyOtpUsecase(this._authRepository);

  @override
  Future<DataState<UserEntity>> call({VerifyOtpRequest? params}) {
    return _authRepository.verifyOtp(params!);
  }
}
