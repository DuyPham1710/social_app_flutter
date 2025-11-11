import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/privacy/domain/entities/privacy_entity.dart';

abstract class PrivacyRepository {
  Future<DataState<PrivacyEntity>> getDefaultPrivacy();

  Future<DataState<PrivacyEntity>> setDefaultPrivacy(
    PrivacyEntity privacyEntity,
  );
}
