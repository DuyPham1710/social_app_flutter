import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/privacy/data/data_sources/remote/privacy_remote_data_source.dart';
import 'package:social_app_fe/features/privacy/data/models/privacy_model.dart';
import 'package:social_app_fe/features/privacy/data/models/update_privacy_model.dart';
import 'package:social_app_fe/features/privacy/domain/entities/privacy_entity.dart';
import 'package:social_app_fe/features/privacy/domain/repository/privacy_repository.dart';

class PrivacyRepositoryImpl implements PrivacyRepository {
  final PrivacyRemoteDataSource remoteDataSource;

  PrivacyRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<PrivacyModel>> getDefaultPrivacy() async {
    try {
      final response = await remoteDataSource.getDefaultPrivacy();

      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<PrivacyModel>> setDefaultPrivacy(
    PrivacyEntity privacyEntity,
  ) async {
    try {
      final updateModel = UpdatePrivacyModel(
        defaultPrivacy: privacyEntity.defaultPrivacy,
        friendsExcept: privacyEntity.friendsExcept
            ?.map((e) => e.userId)
            .toList(),
        friendsDetail: privacyEntity.friendsDetail
            ?.map((e) => e.userId)
            .toList(),
      );

      final response = await remoteDataSource.setDefaultPrivacy(updateModel);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
