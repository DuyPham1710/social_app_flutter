import 'dart:io';
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

  @GET('/user/{id}')
  Future<UserModel> getUserProfileById(@Path('id') String id);

  @MultiPart()
  @PATCH('/user')
  Future<UserModel> updateUserProfile({
    @Part(name: 'fullName') String? fullName,
    @Part(name: 'phoneNumber') String? phoneNumber,
    @Part(name: 'dateOfBirth') String? dateOfBirth,
    @Part(name: 'gender') String? gender,
    @Part(name: 'bio') String? bio,
    @Part(name: 'school') String? school,
    @Part(name: 'currentCity') String? currentCity,
    @Part(name: 'hometown') String? hometown,
    @Part(name: 'workplace') String? workplace,
    @Part(name: 'relationshipStatus') String? relationshipStatus,
    @Part(name: 'file') File? avatarFile,
    @Part(name: 'cover') File? coverFile,
  });
}
