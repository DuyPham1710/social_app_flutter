import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
part 'user_remote_data_source.g.dart';


@RestApi()
abstract class UserRemoteDataSource {
  factory UserRemoteDataSource(Dio dio, {String baseUrl}) =
      _UserRemoteDataSource;

  @GET('/user/profile')
  Future<UserModel> getUserProfile();
}

