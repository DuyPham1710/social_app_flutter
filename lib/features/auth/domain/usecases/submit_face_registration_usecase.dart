import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class SubmitFaceRegistrationParams {
  final String userId;
  final List<String> base64Images;

  SubmitFaceRegistrationParams({
    required this.userId,
    required this.base64Images,
  });
}

class SubmitFaceRegistrationUsecase
    implements
        UseCase<DataState<Map<String, dynamic>>, SubmitFaceRegistrationParams> {
  final AuthRepository _authRepository;

  SubmitFaceRegistrationUsecase(this._authRepository);

  @override
  Future<DataState<Map<String, dynamic>>> call({
    SubmitFaceRegistrationParams? params,
  }) {
    return _authRepository.registerFace(
      params!.userId,
      params.base64Images,
    );
  }
}
