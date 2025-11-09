import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/privacy/domain/entities/privacy_entity.dart';
import 'package:social_app_fe/features/privacy/domain/repository/privacy_repository.dart';

class SetDefaultPrivacyUseCase
    implements UseCase<DataState<PrivacyEntity>, PrivacyEntity> {
  final PrivacyRepository repository;

  SetDefaultPrivacyUseCase(this.repository);
  @override
  Future<DataState<PrivacyEntity>> call({PrivacyEntity? params}) {
    return repository.setDefaultPrivacy(params!);
  }
}
