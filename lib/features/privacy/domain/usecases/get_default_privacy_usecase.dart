import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/privacy/domain/entities/privacy_entity.dart';
import 'package:social_app_fe/features/privacy/domain/repository/privacy_repository.dart';

class GetDefaultPrivacyUseCase
    implements UseCase<DataState<PrivacyEntity>, void> {
  final PrivacyRepository repository;

  GetDefaultPrivacyUseCase(this.repository);

  @override
  Future<DataState<PrivacyEntity>> call({void params}) {
    return repository.getDefaultPrivacy();
  }
}
