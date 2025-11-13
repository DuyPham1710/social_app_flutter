import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/domain/repository/user_repository.dart';

class GetUserProfileUseCase implements UseCase<DataState<UserEntity>, void> {
  final UserRepository _userRepository;

  GetUserProfileUseCase(this._userRepository);

  @override
  Future<DataState<UserEntity>> call({void params}) {
    return _userRepository.getUserProfile();
  }

  
}
