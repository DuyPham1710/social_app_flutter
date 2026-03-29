import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_app_fe/features/save/data/models/saved_model.dart';
import 'package:social_app_fe/features/save/data/models/saved_list_model.dart';

part 'save_remote_data_source.g.dart';

@RestApi()
abstract class SaveRemoteDataSource {
  factory SaveRemoteDataSource(Dio dio) = _SaveRemoteDataSource;

  @POST('/save')
  Future<SavedModel> savePost(@Body() Map<String, dynamic> body);

  @DELETE('/save/{id}')
  Future<void> unsavePost(@Path('id') String id);

  @GET('/save/check/{targetId}/{type}')
  Future<bool> checkSaved(
    @Path('targetId') String targetId,
    @Path('type') String type,
  );

  @GET('/save')
  Future<SavedListModel> getSavedByUser({
    @Query('type') String? type,
    @Query('collection') String? collection,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });
}
