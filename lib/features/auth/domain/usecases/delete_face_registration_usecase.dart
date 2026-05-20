import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class DeleteFaceRegistrationUsecase
    implements UseCase<DataState<Map<String, dynamic>>, void> {
  final AuthRepository _authRepository;

  DeleteFaceRegistrationUsecase(this._authRepository);

  @override
  Future<DataState<Map<String, dynamic>>> call({void params}) {
    return _authRepository.deleteFaceRegistration();
  }
}
