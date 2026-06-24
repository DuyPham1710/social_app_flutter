import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';

class GoogleAuthUsecase extends UseCase<DataState<Map<String, dynamic>>, String> {
  final AuthRepository authRepository;

  GoogleAuthUsecase(this.authRepository);

  @override
  Future<DataState<Map<String, dynamic>>> call({String? params}) {
    return authRepository.googleAuth(params!);
  }
}
