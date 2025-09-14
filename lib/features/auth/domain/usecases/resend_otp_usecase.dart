import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class ResendOtpUsecase implements UseCase<DataState<String>, String> {
  final AuthRepository _authRepository;

  ResendOtpUsecase(this._authRepository);

  @override
  Future<DataState<String>> call({String? params}) {
    return _authRepository.resendOtp(params!);
  }
}
