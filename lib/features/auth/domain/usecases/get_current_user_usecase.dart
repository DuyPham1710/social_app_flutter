import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/auth/domain/repository/auth_repository.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class GetCurrentUserUseCase extends UseCase<DataState<UserEntity>, void> {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<DataState<UserEntity>> call({void params}) {
    return _repository.getCurrentUser();
  }
}
