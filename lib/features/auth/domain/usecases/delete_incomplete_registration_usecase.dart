import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class DeleteIncompleteRegistrationUsecase implements UseCase<DataState<void>, String> {
  final AuthRepository _authRepository;

  DeleteIncompleteRegistrationUsecase(this._authRepository);

  @override
  Future<DataState<void>> call({String? params}) {
    return _authRepository.deleteIncompleteRegistration(params!);
  }
}
