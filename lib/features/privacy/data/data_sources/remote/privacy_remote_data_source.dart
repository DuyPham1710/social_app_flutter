import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_app_fe/features/privacy/data/models/privacy_model.dart';
import 'package:social_app_fe/features/privacy/data/models/update_privacy_model.dart';

part 'privacy_remote_data_source.g.dart';

@RestApi()
abstract class PrivacyRemoteDataSource {
  factory PrivacyRemoteDataSource(Dio dio) = _PrivacyRemoteDataSource;

  @GET('/privacy/default')
  Future<PrivacyModel> getDefaultPrivacy();

  @PATCH('/privacy/default')
  Future<PrivacyModel> setDefaultPrivacy(
    @Body() UpdatePrivacyModel privacyEntity,
  );
}
